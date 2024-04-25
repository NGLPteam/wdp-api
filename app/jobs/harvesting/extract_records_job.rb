# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::ExtractRecords
  class ExtractRecordsJob < ApplicationJob
    queue_as :extraction

    unique_job! by: :all_args

    # @param [HarvestAttempt] harvest_attempt
    # @param [String, nil] cursor
    # @return [void]
    def perform(harvest_attempt, cursor: nil)
      call_operation! "harvesting.actions.extract_records", harvest_attempt, async: true, cursor:, skip_prepare: true

      Harvesting::ReprocessAttemptJob.perform_later harvest_attempt if harvest_attempt.record_extraction_progress.done?
    end
  end
end
