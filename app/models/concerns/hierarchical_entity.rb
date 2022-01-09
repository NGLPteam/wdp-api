# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
module HierarchicalEntity
  extend ActiveSupport::Concern

  include HasSystemSlug
  include SyncsEntities
  include TimestampScopes

  included do
    include ImageUploader::Attachment.new(:hero_image)
    include ImageUploader::Attachment.new(:thumbnail)

    delegate :auth_path, to: :contextual_parent, allow_nil: true, prefix: :contextual

    has_many :hierarchical_entity_entries, as: :hierarchical, dependent: :destroy,
      class_name: "Entity"

    has_many :named_ancestors, -> { in_default_order.preload(:ancestor) }, class_name: "EntityAncestor", as: :entity
    has_many :named_descendants, class_name: "EntityAncestor", as: :ancestor

    has_many :entity_links, as: :source, dependent: :destroy
    has_many :incoming_links, as: :target, class_name: "EntityLink", dependent: :destroy

    has_many :linked_entities, through: :entity_links, source: :target
    has_many :linking_entities, through: :incoming_links, source: :source

    has_many :contextual_permissions, as: :hierarchical
    has_many :contextual_single_permissions, as: :hierarchical

    has_many :assigned_users, through: :contextual_permissions, source: :user

    has_many :entity_breadcrumbs, -> { order(depth: :asc) }, as: :entity
    has_many :entity_breadcrumb_entries, class_name: "EntityBreadcrumb", as: :crumb

    has_many :entity_inherited_orderings, as: :entity, inverse_of: :entity

    has_many :hierarchical_schema_ranks, -> { for_association }, as: :entity
    has_many :hierarchical_schema_version_ranks, -> { for_association }, as: :entity

    has_many :link_target_candidates, as: :source

    has_many :orderings, dependent: :destroy, as: :entity

    has_many :ordering_entries, dependent: :destroy, as: :entity

    has_many :parent_orderings, through: :ordering_entries, source: :ordering

    has_many :pages, -> { in_default_order }, as: :entity, dependent: :destroy

    scope :sans_thumbnail, -> { where(arel_json_get(:thumbnail_data, :storage).eq(nil)) }

    scope :filtered_by_schema_version, ->(schemas) { where(schema_version: SchemaVersion.filtered_by(schemas)) }

    scope :with_missing_orderings, -> { where(id: EntityInheritedOrdering.missing.select(:entity_id)) }

    scope :with_schema_name_asc, -> { joins(:schema_definition).merge(SchemaDefinition.order(name: :asc)) }

    scope :with_schema_name_desc, -> { joins(:schema_definition).merge(SchemaDefinition.order(name: :desc)) }

    before_validation :inherit_hierarchical_parent!

    after_validation :set_temporary_auth_path!, on: :create
    after_validation :maybe_update_auth_path!, on: :update

    after_create :populate_initial_orderings!

    after_save :track_parent_changes!

    after_save :maintain_links!

    after_save :refresh_orderings!
  end

  # @param [String] ancestor_name
  # @return [EntityAncestor, nil]
  def ancestor_by_name(ancestor_name)
    named_ancestors.by_name(ancestor_name).first&.ancestor
  end

  # @param [String] schema_name
  # @return [HierarchicalEntity]
  def ancestor_of_type(schema_name)
    entity_breadcrumbs.filtered_by_schema_version(schema_name).first&.crumb
  end

  # @return [String]
  def breadcrumb_label
    title
  end

  # This potentially connects to another "layer" in the hierarchy.
  #
  # For items, it can be an item or a collection.
  #
  # For collections, it can be a collection or a community.
  #
  # For communities, it's always nil.
  #
  # @return [HierarchicalEntity, nil]
  def contextual_parent
    root? ? hierarchical_parent : parent
  end

  # @return [Symbol, nil]
  def contextual_parent_foreign_key
    contextual_parent.then do |parent|
      :"#{parent.hierarchical_child_association}_id" if parent.present?
    end
  end

  # @!scope private
  # @return [String]
  def derive_auth_path
    return unless persisted? && system_slug?

    [contextual_auth_path, system_slug].compact.join(?.)
  end

  # @abstract
  # @return [ActiveRecord::Relation<HierarchicalEntity>]
  def hierarchical_children
    self.class.none
  end

  def hierarchical_child_association
    model_name.singular.to_sym
  end

  # @abstract
  def hierarchical_parent
    # :nocov:
    raise NotImplementedError, "Must implement #{self.class}##{__method__}"
    # :nocov:
  end

  def hierarchical_parent_foreign_key
    :"#{hierarchical_parent&.hierarchical_child_association}_id" if hierarchical_parent.present?
  end

  # @see Links::Connect
  # @param [HierarchicalEntity] source
  # @param [String] operator
  # @return [Dry::Monads::Result]
  def link_from!(source, operator:)
    call_operation("links.connect", source, self, operator)
  end

  # @see Links::Connect
  # @param [HierarchicalEntity] target
  # @param [String] operator
  # @return [Dry::Monads::Result]
  def link_to!(target, operator:)
    call_operation("links.connect", self, target, operator)
  end

  def maintain_links
    call_operation("links.maintain", self)
  end

  def maintain_links!
    maintain_links.value!
  end

  # @param [String] identifier
  # @return [Ordering, nil]
  def ordering(identifier)
    if orderings.loaded?
      orderings.detect { |ord| ord.identifier == identifier }
    else
      orderings.by_identifier(identifier).first
    end
  end

  # @param [String] identifier
  # @raise [ActiveRecord::RecordNotFound]
  # @return [Ordering]
  def ordering!(identifier)
    orderings.by_identifier(identifier).first!
  end

  # @see Schemas::Instances::PopulateOrderings
  # @return [Dry::Monads::Result]
  def populate_orderings!
    call_operation("schemas.instances.populate_orderings", self)
  end

  # @return [void]
  def populate_initial_orderings!
    populate_orderings!.value!
  end

  # @see Schemas::Instances::RefreshOrderings
  # @return [Dry::Monads::Result]
  def refresh_orderings
    call_operation("schemas.instances.refresh_orderings", self)
  end

  def refresh_orderings!
    refresh_orderings.value!
  end

  def top_level?
    kind_of?(Community) || (respond_to?(:root?) && root?)
  end

  def has_permitted_actions_for?(user, *actions)
    return unless persisted?

    contextual_single_permissions.with_permitted_actions_for(user, *actions).exists?
  end

  # If a parent collection changes its community, we need its children to to also inherit that update.
  #
  # So too with items' parents getting new collections.
  #
  # @!scope private
  # @return [void]
  def inherit_hierarchical_parent!
    return if top_level?

    inherited_hierarchical_parent = parent.hierarchical_parent

    return if inherited_hierarchical_parent.blank?

    writer = :"#{inherited_hierarchical_parent.hierarchical_child_association}="

    public_send writer, inherited_hierarchical_parent
  end

  # @see Loaders::ContextualPermissionLoader
  # @return [String]
  def loader_cache_key
    "#{hierarchical_type}:#{hierarchical_id}"
  end

  # @!scope private
  # @return [void]
  def maybe_update_auth_path!
    return unless persisted? && system_slug?

    self.auth_path = derive_auth_path
  end

  # @return [void]
  def set_system_slug!
    super

    update_column :auth_path, derive_auth_path
  end

  def to_entity_tuple
    super.merge(
      slice(
        :schema_version_id,
        :title,
        :created_at,
        :updated_at,
      ).symbolize_keys
    )
  end

  def saved_change_to_contextual_parent?
    saved_change_to_attribute? contextual_parent_foreign_key
  end

  def saved_change_to_hierarchical_parent?
    saved_change_to_attribute? hierarchical_parent_foreign_key
  end

  def should_update_hierarchical_children_after_save?
    saved_change_to_contextual_parent? || saved_change_to_hierarchical_parent? || saved_change_to_auth_path?
  end

  # @see #inherit_hierarchical_parent!
  # @!scope private
  # @return [void]
  def track_parent_changes!
    return if top_level?

    return unless should_update_hierarchical_children_after_save?

    # This will have a cascading effect on all descendants, as they should each inherit
    # the updated parent, triggering this method at their depth, and then doing the same
    # for each of their children, and so on.
    children.find_each(&:save!)

    # For collections, this will make sure that items update their auth_paths
    hierarchical_children.find_each(&:save!)
  end

  # @return [void]
  def set_temporary_auth_path!
    self.auth_path = system_slug
  end

  module ClassMethods
    # @param [User] user
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def readable_by(user)
      with_permitted_actions_for(user, "self.read")
    end

    # @param [User] user
    # @param [<String>] actions
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def with_permitted_actions_for(user, *actions)
      constraint = ContextualSinglePermission.for_hierarchical_type(model_name.to_s).with_permitted_actions_for(user, *actions).select(:hierarchical_id)

      where(id: constraint)
    end
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent, Rails/InverseOf
