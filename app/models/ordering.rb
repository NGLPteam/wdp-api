# frozen_string_literal: true

# A dynamic ordering for a {SchemaInstance}. By default, these are provided by the
# entity's associated {SchemaVersion}, but there exists the ability for administrators
# to create custom orderings for specific entities that have all the same abilities.
#
# @see Schemas::Orderings::Definition
# @see Schemas::Versions::Configuration#orderings
class Ordering < ApplicationRecord
  include AssignsPolymorphicForeignKey
  include ReloadAfterSave

  attr_readonly :constant, :disabled, :hidden, :identifier, :name

  belongs_to :entity, polymorphic: true
  belongs_to :schema_version

  belongs_to :community, optional: true
  belongs_to :collection, optional: true
  belongs_to :item, optional: true

  has_one :schema_definition, through: :schema_version

  has_many :ordering_entries, -> { preload(:entity) }, inverse_of: :ordering, dependent: :delete_all

  # @!attribute [rw] definition
  # @return [Schemas::Orderings::Definition]
  attribute :definition, Schemas::Orderings::Definition.to_type, default: proc { {} }

  scope :by_entity, ->(entity) { where(entity: entity) }
  scope :by_identifier, ->(identifier) { where(identifier: identifier) }

  scope :deterministically_ordered, -> { reorder(position: :asc, name: :asc, identifier: :asc) }

  scope :enabled, -> { where(disabled_at: nil) }
  scope :disabled, -> { where.not(disabled_at: nil) }
  scope :hidden, -> { where(hidden: true) }
  scope :visible, -> { where(hidden: false) }

  delegate :header, :footer, :tree_mode?, to: :definition

  delegate :schemas, allow_nil: true, to: "definition.filter", prefix: :filter

  before_validation :sync_inherited!

  # A restrictive pattern to ensure that ordering identifiers are sane, URL-safe,
  # and consistent across the application.
  IDENTIFIER_FORMAT = /\A[a-z](?:[a-z0-9]*|(?:(?<![-_])[_-](?![_-])))*[a-z0-9]\z/.freeze

  validates :identifier, presence: true, format: { with: IDENTIFIER_FORMAT }, uniqueness: { scope: %i[entity_type entity_id] }
  validates :definition, store_model: true

  after_save :refresh!

  assign_polymorphic_foreign_key! :entity, :community, :collection, :item

  # @return [void]
  def asynchronously_refresh!
    Schemas::Orderings::RefreshJob.perform_later self
  end

  # @return [void]
  def asynchronously_reset!
    Schemas::Orderings::ResetJob.perform_later self
  end

  # @see Schemas::Orderings::OrderBuilder::Compile
  # @return [Schemas::Ordering::OrderExpression]
  def compile_ordering_expression
    call_operation("schemas.orderings.order_builder.compile", definition)
  end

  def disabled?
    disabled_at.present?
  end

  # @return [<Schemas::Orderings::OrderDefinition>]
  def order_definitions
    Array(definition.order)
  end

  # @see Schemas::Orderings::Refresh
  # @return [Dry::Monads::Result]
  def refresh
    call_operation("schemas.orderings.refresh", self)
  end

  def refresh!
    refresh.value!
  end

  # @see Schemas::Orderings::Reset
  # @return [Dry::Monads::Result]
  def reset!
    call_operation("schemas.orderings.reset", self)
  end

  # @return [void]
  def sync_inherited!
    self.inherited_from_schema = schema_version ? schema_version.has_ordering?(identifier) : false
  end

  class << self
    def owned_by_or_ordering(entity)
      base_query = unscoped.by_entity(entity)

      base_query = base_query.or unscoped.where(id: entity.parent_orderings)

      base_query = base_query.or unscoped.where(id: OrderingEntry.linking_to(entity).select(:ordering_id))

      where id: base_query
    end
  end
end
