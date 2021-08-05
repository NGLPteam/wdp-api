# frozen_string_literal: true

class Ordering < ApplicationRecord
  include AssignsPolymorphicForeignKey

  belongs_to :entity, polymorphic: true
  belongs_to :schema_version

  belongs_to :community, optional: true
  belongs_to :collection, optional: true
  belongs_to :item, optional: true

  has_one :schema_definition, through: :schema_version

  has_many :ordering_entries, -> { preload(:entity).in_order }, inverse_of: :ordering

  attribute :definition, Schemas::Orderings::Definition.to_type, default: proc { {} }

  scope :by_entity, ->(entity) { where(entity: entity) }
  scope :by_identifier, ->(identifier) { where(identifier: identifier) }

  scope :enabled, -> { where(disabled_at: nil) }
  scope :disabled, -> { where.not(disabled_at: nil) }

  delegate :name, :header, :footer, to: :definition

  delegate :schemas, allow_nil: true, to: "definition.filter", prefix: :filter

  before_validation :sync_inherited!

  IDENTIFIER_FORMAT = /\A[a-z][a-z0-9_]*[a-z]\z/.freeze

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

  def disabled?
    disabled_at.present?
  end

  # @return [<Schemas::Orderings::OrderDefinition>]
  def order_definitions
    Array(definition.order)
  end

  # @return [Dry::Monads::Result]
  def refresh
    call_operation("schemas.orderings.refresh", self)
  end

  def refresh!
    refresh.value!
  end

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
