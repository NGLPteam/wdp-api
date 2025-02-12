# frozen_string_literal: true

class HarvestRecord < ApplicationRecord
  include HasHarvestErrors
  include ScopesForIdentifier
  include ScopesForMetadataFormat
  include TimestampScopes

  belongs_to :harvest_attempt, inverse_of: :harvest_records

  has_one :harvest_source, through: :harvest_attempt
  has_one :harvest_mapping, through: :harvest_attempt
  has_one :harvest_set, through: :harvest_attempt

  has_many :harvest_entities, -> { in_default_order }, inverse_of: :harvest_record, dependent: :destroy
  has_many :harvest_contributions, through: :harvest_entities
  has_many :harvest_contributors, through: :harvest_contributions

  has_many_readonly :collections, through: :harvest_entities, source: :entity, source_type: "Collection"
  has_many_readonly :items, through: :harvest_entities, source: :entity, source_type: "Item"

  attribute :skipped, Harvesting::Records::Skipped.to_type, default: proc { {} }

  scope :current, -> { where(harvest_attempt: HarvestAttempt.current) }
  scope :previous, -> { where(harvest_attempt: HarvestAttempt.previous) }

  scope :by_metadata_kind, ->(kind) { where(id: HarvestEntity.by_metadata_kind(kind).select(:harvest_record_id)) }
  scope :filtered_by_schema_version, ->(version) { where(id: HarvestEntity.filtered_by_schema_version(version).select(:harvest_record_id)) }
  scope :latest_attempt, -> { where(harvest_attempt_id: ::HarvestAttempt.in_recent_order.limit(1).select(:id)) }
  scope :skipped, -> { where(has_been_skipped: true) }
  scope :unskipped, -> { where(has_been_skipped: false) }
  scope :upsertable, -> { unskipped.sans_harvest_errors }
  scope :with_entities, -> { where(id: HarvestEntity.select(:harvest_record_id)) }
  scope :unprepared, -> { where.not(id: HarvestEntity.select(:harvest_record_id)) }

  scope :sans_extracted_scalar_asset, ->(full_path) { with_entities.where.not(id: unscoped.with_extracted_scalar_asset(full_path)) }
  scope :with_extracted_scalar_asset, ->(full_path) { where(id: HarvestEntity.with_extracted_scalar_asset(full_path).select(:harvest_record_id)) }

  scope :in_default_order, -> { in_recent_order }
  scope :in_inverse_order, -> { in_oldest_order }

  # @api private
  # @return [void]
  def clear_skip!
    self.skipped = Harvesting::Records::Skipped.blank

    save!
  end

  def inspect
    "HarvestRecord[:#{metadata_format}](#{identifier.inspect})"
  end

  # Perform {#prepare_entities!} asynchronously.
  #
  # @see Harvesting::PrepareEntitiesFromRecordJob
  # @return [void]
  def asynchronously_prepare_entities!
    Harvesting::PrepareEntitiesFromRecordJob.perform_later self
  end

  # Perform {#reextract!} asynchronously.
  #
  # @see Harvesting::ReextractRecordJob
  # @return [void]
  def asynchronously_reextract!
    Harvesting::ReextractRecordJob.perform_later self
  end

  # Perform {#upsert_entities!} asynchronously.
  #
  # @see Harvesting::UpsertEntitiesForRecordJob
  # @param [Boolean] reprepare
  # @return [void]
  def asynchronously_upsert_entities!(reprepare: false)
    Harvesting::UpsertEntitiesForRecordJob.perform_later self, reprepare:
  end

  monadic_operation! def metadata_values
    parse_metadata.bind(&:extract_values)
  end

  # @see Harvesting::Actions::ParseRecordMetadata
  # @return [Dry::Monads::Result]
  def parse_metadata
    call_operation("harvesting.actions.parse_record_metadata", self)
  end

  # @see Harvesting::Actions::PrepareEntitiesFromRecord
  # @return [Dry::Monads::Result]
  def prepare_entities!
    call_operation("harvesting.actions.prepare_entities_from_record", self)
  end

  # Re-extract the record based on the defined protocol and metadata format.
  #
  # This will also {#prepare_entities! re-prepare} and {#upsert_entities! re-upsert}
  # the entity, since it's assumed the underlying data might have changed.
  #
  # @see Harvesting::Actions::ReextractRecord
  # @return [Dry::Monads::Result]
  def reextract!
    call_operation("harvesting.actions.reextract_record", self)
  end

  # @see Harvesting::Actions::UpsertEntities
  # @param [Boolean] reprepare
  # @return [Dry::Monads::Result]
  def upsert_entities!(reprepare: false)
    call_operation("harvesting.actions.upsert_entities", self, reprepare:)
  end

  class << self
    # Return the most recent {HarvestRecord} instance from the current attempts
    # for a given `sourcelike` that is identified by `identifier`.
    #
    # @param [String, HarvestSource] sourcelike
    # @param [String] identifier
    # @return [HarvestRecord]
    def fetch_for_source(sourcelike, identifier)
      for_source_by_identifier(sourcelike, identifier).first
    end

    # Return the most recent {HarvestRecord} instance from the current attempts
    # for a given `sourcelike` that is identified by `identifier`.
    #
    # Raise an error if one is not found.
    #
    # @param [String, HarvestSource] sourcelike
    # @param [String] identifier
    # @raise [Harvesting::Records::Unknown]
    # @return [HarvestRecord]
    def fetch_for_source!(sourcelike, identifier)
      for_source_by_identifier(sourcelike, identifier).first!
    rescue ActiveRecord::RecordNotFound
      raise Harvesting::Records::Unknown, identifier
    end

    # @see HarvestAttempt.for_source
    # @param [String, HarvestSource] sourcelike
    # @return [ActiveRecord::Relation<HarvestRecord>]
    def for_source(sourcelike)
      where(harvest_attempt: HarvestAttempt.for_source(sourcelike))
    end

    # @api private
    # @see .fetch_for_source
    # @see .fetch_for_source!
    # @param [String, HarvestSource] sourcelike
    # @param [String] identifier
    # @return [ActiveRecord::Relation<HarvestRecord>]
    def for_source_by_identifier(sourcelike, identifier)
      current_for_source(sourcelike).identified_by(identifier).in_recent_order
    end

    # @see HarvestAttempt.current_for_source
    # @param [String, HarvestSource] sourcelike
    # @return [ActiveRecord::Relation<HarvestRecord>]
    def latest_for_source(sourcelike)
      where(harvest_attempt: HarvestAttempt.current_for_source(sourcelike))
    end

    alias current_for_source latest_for_source
  end
end
