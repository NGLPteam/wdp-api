# frozen_string_literal: true

module Harvesting
  # This is a manual job that can be invoked to handle failed upserts
  # on very slow upstreams that cannot handle multiple concurrent connections.
  class RetryFailedUpsertsJob < ApplicationJob
    queue_as :harvesting

    include JobIteration::Iteration

    unique :until_and_while_executing, lock_ttl: 1.hour, on_conflict: :log

    # @param [HarvestAttempt] harvest_attempt
    # @param [Object] cursor
    # @return [void]
    def build_enumerator(harvest_attempt, cursor:)
      enumerator_builder.active_record_on_records(
        harvest_attempt.harvest_records.with_coded_harvest_errors("failed_entity_upsert"),
        cursor: cursor
      )
    end

    # @param [HarvestRecord] harvest_record
    # @return [void]
    def each_iteration(harvest_record, _harvest_attempt)
      harvest_record.upsert_entities!
    end
  end
end
