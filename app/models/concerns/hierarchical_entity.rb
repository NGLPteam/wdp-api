# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
module HierarchicalEntity
  extend ActiveSupport::Concern

  include HasSystemSlug

  included do
    include EntityImageUploader::Attachment.new(:thumbnail)

    delegate :auth_path, to: :contextual_parent, allow_nil: true, prefix: :contextual

    has_one :entity, as: :entity, dependent: :destroy

    has_many :contextual_permissions, as: :hierarchical
    has_many :contextual_single_permissions, as: :hierarchical

    has_many :entity_breadcrumbs, -> { order(depth: :asc) }, as: :entity
    has_many :entity_breadcrumb_entries, class_name: "EntityBreadcrumb", as: :crumb

    scope :sans_thumbnail, -> { where(arel_json_get(:thumbnail_data, :storage).eq(nil)) }

    before_validation :inherit_hierarchical_parent!

    after_validation :set_temporary_auth_path!, on: :create
    after_validation :maybe_update_auth_path!, on: :update

    after_save :track_parent_changes!
  end

  # @return [String]
  def breadcrumb_label
    case self
    when Community then name
    else
      title
    end
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

  # @return [String]
  def entity_scope
    model_name.collection
  end

  # @abstract
  # @return [ActiveRecord::Relation<HierarchicalEntity>]
  def hierarchical_children
    self.class.none
  end

  def hierarchical_child_association
    model_name.singular.to_sym
  end

  def hierarchical_id
    id
  end

  alias entity_id hierarchical_id

  # @abstract
  def hierarchical_parent
    # :nocov:
    raise NotImplementedError, "Must implement #{self.class}##{__method__}"
    # :nocov:
  end

  def hierarchical_parent_foreign_key
    :"#{hierarchical_parent&.hierarchical_child_association}_id" if hierarchical_parent.present?
  end

  def hierarchical_type
    model_name.to_s
  end

  alias entity_type hierarchical_type

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

    sync_entity!
  end

  # @!scope private
  # @return [void]
  def sync_entity!
    Entity.upsert(to_entity_tuple, unique_by: %i[entity_type entity_id])

    Entities::CalculateAuthorizing.new.call auth_path: auth_path
  end

  # @return [Hash]
  def to_entity_tuple
    slice(:entity_id, :entity_type, :hierarchical_id, :hierarchical_type, :auth_path, :system_slug).merge(scope: entity_scope)
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
