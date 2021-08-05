# frozen_string_literal: true

class EntityLink < ApplicationRecord
  include HasSystemSlug
  include MatchesScopes

  pg_enum! :operator, as: :link_operator, _prefix: :operator

  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true
  belongs_to :schema_version, inverse_of: :entity_links

  has_one :entity, as: :entity, dependent: :destroy

  has_many :ordering_entries, as: :entity, dependent: :destroy

  belongs_to :source_community, optional: true
  belongs_to :source_collection, optional: true
  belongs_to :source_item, optional: true
  belongs_to :target_community, optional: true
  belongs_to :target_collection, optional: true
  belongs_to :target_item, optional: true

  scope :by_source, ->(source) { where(source: source) }
  scope :by_target, ->(target) { where(target: target) }
  scope :by_source_or_target, ->(entity) { where(id: unscoped.by_source(entity).or(unscoped.by_target(entity))) }

  before_validation :calculate_auth_path!
  before_validation :calculate_scope!
  before_validation :sync_schema_version!

  validate :enforce_types!
  validate :disallow_parents!
  validate :disallow_self!

  validates :auth_path, :scope, presence: true
  validates :scope, inclusion: { in: Links::Types::SCOPE_VALUES }
  validates :target_id, uniqueness: { scope: %i[source_type source_id target_type] }

  after_save :sync_entity!

  after_save :refresh_source_orderings!

  alias_attribute :hierarchical_type, :target_type
  alias_attribute :hierarchical_id, :target_id

  # @api private
  # @return [String, nil]
  def calculate_auth_path
    return unless source.present? && target.present?

    "#{source.auth_path}.#{target.system_slug}"
  end

  # @api private
  # @return [void]
  def calculate_auth_path!
    self.auth_path = calculate_auth_path
  end

  # @api private
  # @return [String, nil]
  def calculate_scope
    call_operation("links.calculate_scope", source_type, target_type).value_or(nil)
  end

  # @api private
  # @return [void]
  def calculate_scope!
    self.scope = calculate_scope
  end

  def has_valid_source?
    source.kind_of?(HierarchicalEntity)
  end

  def has_valid_target?
    target.kind_of?(HierarchicalEntity)
  end

  # @api private
  # @return [void]
  def disallow_parents!
    errors.add :source, :linked_to_parent if source == target.parent
    errors.add :target, :linked_to_parent if source.parent == target
  end

  # @api private
  # @return [void]
  def disallow_self!
    errors.add :target, :linked_to_itself if source == target
  end

  # @api private
  # @return [void]
  def enforce_types!
    errors.add :source, :must_be_entity unless has_valid_source?
    errors.add :target, :must_be_entity unless has_valid_target?
  end

  # @api private
  # @return [void]
  def sync_schema_version!
    self.schema_version = target.respond_to?(:schema_version) ? target.schema_version : nil
  end

  def entity_type
    model_name.to_s
  end

  # @api private
  # @return [void]
  def sync_entity!
    Entity.upsert(to_entity_tuple, unique_by: %i[entity_type entity_id])

    Entities::CalculateAuthorizing.new.call auth_path: auth_path
  end

  # @return [Hash]
  def to_entity_tuple
    slice(
      :entity_type, :hierarchical_id, :hierarchical_type, :schema_version_id,
      :auth_path, :system_slug, :created_at, :updated_at
    ).merge(entity_id: id, scope: scope, link_operator: operator)
  end

  # @api private
  # @return [void]
  def refresh_source_orderings!
    source.refresh_orderings!
  end
end
