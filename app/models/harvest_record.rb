# frozen_string_literal: true

class HarvestRecord < ApplicationRecord
  include HasHarvestErrors
  include ScopesForIdentifier
  include ScopesForMetadataFormat

  belongs_to :harvest_attempt, inverse_of: :harvest_records

  has_one :harvest_source, through: :harvest_attempt
  has_one :harvest_mapping, through: :harvest_attempt
  has_one :harvest_set, through: :harvest_attempt

  has_many :harvest_entities, inverse_of: :harvest_record, dependent: :destroy

  has_many_readonly :collections, through: :harvest_entities, source: :entity, source_type: "Collection"
  has_many_readonly :items, through: :harvest_entities, source: :entity, source_type: "Item"

  scope :by_metadata_kind, ->(kind) { where(id: HarvestEntity.by_metadata_kind(kind).select(:harvest_record_id)) }
  scope :latest_attempt, -> { where(harvest_attempt_id: ::HarvestAttempt.in_recent_order.limit(1).select(:id)) }

  def inspect
    "HarvestRecord[:#{metadata_format}](#{identifier.inspect})"
  end

  # @return [void]
  def asynchronously_prepare_entities!
    Harvesting::PrepareEntitiesFromRecordJob.perform_later self
  end

  # @return [void]
  def asynchronously_upsert_entities!
    Harvesting::UpsertEntitiesForRecordJob.perform_later self
  end

  # @see Harvesting::Actions::PrepareEntitiesFromRecord
  # @return [Dry::Monads::Result]
  def prepare_entities!
    call_operation("harvesting.actions.prepare_entities_from_record", self)
  end

  # @see Harvesting::Actions::UpsertEntities
  # @param [Boolean] reprepare
  # @return [Dry::Monads::Result]
  def upsert_entities!(reprepare: false)
    call_operation("harvesting.actions.upsert_entities", self, reprepare: reprepare)
  end
end
