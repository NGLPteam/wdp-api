# frozen_string_literal: true

module Harvesting
  # Iterate over all harvest records for an attempt and queue a job to reprocess them.
  class ReprocessAttemptJob < ApplicationJob
    queue_as :maintenance

    include JobIteration::Iteration

    unique_job! by: :first_arg

    # @param [HarvestAttempt] harvest_attempt
    # @return [void]
    def build_enumerator(harvest_attempt, cursor:)
      enumerator_builder.active_record_on_records(
        harvest_attempt.harvest_records,
        cursor:
      )
    end

    # @param [HarvestRecord] harvest_record
    # @return [void]
    def each_iteration(harvest_record, _harvest_attempt)
      Harvesting::UpsertEntitiesForRecordJob.perform_later harvest_record, reprepare: true
    end
  end
end
