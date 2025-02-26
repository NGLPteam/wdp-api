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

  has_one_readonly :latest_harvest_attempt_link, inverse_of: :harvest_attempt

  has_many :harvest_records, inverse_of: :harvest_attempt, dependent: :destroy

  has_many :harvest_entities, through: :harvest_records

  scope :current, -> { where(id: LatestHarvestAttemptLink.select(:harvest_attempt_id)) }
  scope :previous, -> { where.not(id: LatestHarvestAttemptLink.select(:harvest_attempt_id)) }

  scope :in_default_order, -> { in_recent_order }
  scope :in_inverse_order, -> { in_oldest_order }

  validates :metadata_format, harvesting_metadata_format: true

  attribute :metadata, Harvesting::Attempts::Metadata.to_type, default: proc { {} }

  alias_attribute :note, :description

  delegate :max_record_count, to: :metadata

  before_validation :inherit_metadata_format!

  def logger
    @logger ||= Harvesting::Logs::Attempt.new self
  end

  # @see Harvesting::Actions::ExtractRecords
  def extract_records!(skip_prepare: false)
    call_operation("harvesting.actions.extract_records", self, skip_prepare:)
  end

  # @see Harvesting::Actions::ReprocessAttempt
  def reprocess!(reprepare: true)
    call_operation("harvesting.actions.reprocess_attempt", self, reprepare:)
  end

  # @see Harvesting::UpsertEntitiesForRecordJob
  def asynchronously_reprocess!(reprepare: true)
    harvest_records.find_each do |record|
      Harvesting::UpsertEntitiesForRecordJob.perform_later record, reprepare:
    end
  end

  # @return [Harvesting::Attempts::RecordExtractionProgress]
  def record_extraction_progress
    @record_extraction_progress ||= Harvesting::Attempts::RecordExtractionProgress.new self
  end

  # @return [void]
  def resume!
    return unless record_extraction_progress.can_resume?

    Harvesting::ExtractRecordsJob.perform_later self, cursor: record_extraction_progress.current_cursor.value
  end

  # @!attribute [r] middleware_parent
  # @return [HarvestMapping, HarvestSource]
  def middleware_parent
    harvest_mapping.presence || harvest_source
  end

  private

  # @return [void]
  def inherit_metadata_format!
    self.metadata_format ||= harvest_mapping&.metadata_format || harvest_source&.metadata_format
  end

  class << self
    # Fetch the current attempts for a given {HarvestSource}.
    #
    # A source can have multiple current attempts, based on whether or not the
    # attempt(s) are also associated with {HarvestMapping}s or {HarvestSet}s.
    #
    # @see .latest_for_source
    # @param [String, HarvestSource] sourcelike
    # @return [ActiveRecord::Relation<HarvestAttempt>]
    def current_for_source(sourcelike)
      for_source(sourcelike).current
    end

    # Fetch all attempts for a given {HavestSource}.
    #
    # @param [String, HarvestSource] sourcelike
    # @return [ActiveRecord::Relation<HarvestAttempt>]
    def for_source(sourcelike)
      where(harvest_source: HarvestSource.identified_by(sourcelike).select(:id))
    end

    # Fetch the latest attempt for a given {HarvestSource}.
    #
    # It will be whichever attempt is created most recently,
    # irrespective of any mapping or set associations.
    #
    # @see .current_for_source
    # @param [String, HarvestSource] sourcelike
    # @return [HarvestAttempt, nil]
    def latest_for_source(sourcelike)
      for_source(sourcelike).latest
    end

    # Iterate over each {HarvestSource}'s latest attempt.
    #
    # @yield [attempt]
    # @yieldparam [HarvestAttempt] attempt
    # @yieldreturn [void]
    # @return [void]
    def latest_for_each_source
      return enum_for(__method__) unless block_given?

      HarvestSource.find_each do |source|
        attempt = latest_for_source source

        next if attempt.blank?

        yield attempt
      end
    end
  end
end
