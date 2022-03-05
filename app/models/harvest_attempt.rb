# frozen_string_literal: true

class HarvestAttempt < ApplicationRecord
  include HasEphemeralSystemSlug
  include ScopesForMetadataFormat
  include TimestampScopes

  belongs_to :target_entity, inverse_of: :harvest_attempts, polymorphic: true
  belongs_to :harvest_source, inverse_of: :harvest_attempts
  belongs_to :harvest_set, inverse_of: :harvest_attempts, optional: true
  belongs_to :harvest_mapping, inverse_of: :harvest_attempts, optional: true

  has_many :harvest_records, inverse_of: :harvest_attempt, dependent: :destroy

  has_many :harvest_entities, through: :harvest_records

  validates :metadata_format, harvesting_metadata_format: true

  before_validation :inherit_metadata_format!

  def logger
    @logger ||= Harvesting::Logs::Attempt.new self
  end

  # @see Harvesting::Actions::ExtractRecords
  def extract_records!(skip_prepare: false)
    call_operation("harvesting.actions.extract_records", self, skip_prepare: skip_prepare)
  end

  def reprocess!(reprepare: true)
    call_operation("harvesting.actions.reprocess_attempt", self, reprepare: reprepare)
  end

  def asynchronously_reprocess!(reprepare: true)
    harvest_records.find_each do |record|
      Harvesting::UpsertEntitiesForRecordJob.perform_later record, reprepare: reprepare
    end
  end

  private

  # @return [void]
  def inherit_metadata_format!
    self.metadata_format ||= harvest_mapping&.metadata_format || harvest_source&.metadata_format
  end
end
