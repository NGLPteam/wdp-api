# frozen_string_literal: true

class HarvestAttempt < ApplicationRecord
  include HasEphemeralSystemSlug
  include HasHarvestErrors
  include ScopesForMetadataFormat
  include TimestampScopes

  belongs_to :target_entity, inverse_of: :harvest_attempts, polymorphic: true
  belongs_to :harvest_source, inverse_of: :harvest_attempts
  belongs_to :harvest_set, inverse_of: :harvest_attempts, optional: true
  belongs_to :harvest_mapping, inverse_of: :harvest_attempts, optional: true

  has_many :harvest_records, inverse_of: :harvest_attempt, dependent: :destroy

  has_many :harvest_entities, through: :harvest_records

  validates :metadata_format, harvesting_metadata_format: true

  attribute :metadata, Harvesting::Attempts::Metadata.to_type, default: proc { {} }

  delegate :max_record_count, to: :metadata

  before_validation :inherit_metadata_format!

  def logger
    @logger ||= Harvesting::Logs::Attempt.new self
  end

  # @see Harvesting::Actions::ExtractRecords
  def extract_records!(skip_prepare: false)
    call_operation("harvesting.actions.extract_records", self, skip_prepare: skip_prepare)
  end

  # @see Harvesting::Actions::UpsertAllEntities
  def reprocess!
    call_operation("harvesting.actions.reprocess_attempt", self, reprepare: true)
  end

  # @see Harvesting::UpsertEntitiesForRecordJob
  def asynchronously_reprocess!(reprepare: true)
    harvest_records.find_each do |record|
      Harvesting::UpsertEntitiesForRecordJob.perform_later record, reprepare: reprepare
    end
  end

  # @return [Harvesting::Attempts::RecordExtractionProgress]
  def record_extraction_progress
    @record_extraction_progress ||= Harvesting::Attempts::RecordExtractionProgress.new self
  end

  private

  # @return [void]
  def inherit_metadata_format!
    self.metadata_format ||= harvest_mapping&.metadata_format || harvest_source&.metadata_format
  end
end
