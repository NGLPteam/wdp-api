# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::ExtractRecords
  class ExtractRecordsJob < ApplicationJob
    queue_as :harvesting

    unique :until_and_while_executing, lock_ttl: 1.hour, on_conflict: :log

    # @param [HarvestAttempt] harvest_attempt
    # @return [void]
    def perform(harvest_attempt)
      call_operation! "harvesting.actions.extract_records", harvest_attempt, skip_prepare: true

      Harvesting::ReprocessAttemptJob.perform_later harvest_attempt
    end
  end
end
