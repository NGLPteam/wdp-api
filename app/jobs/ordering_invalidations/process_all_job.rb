# frozen_string_literal: true

module OrderingInvalidations
  # Iterate through all {OrderingInvalidation} that are marked as stale
  # and refresh them in a serial fashion in order to avoid blowing
  # up the database during high concurrency periods.
  class ProcessAllJob < ApplicationJob
    include JobIteration::Iteration

    good_job_control_concurrency_with(
      total_limit: 1,
      key: "Schemas::Orderings::ProcessInvalidationsJob"
    )

    queue_as :orderings

    # @param [String] before
    # @param [String] cursor
    # @return [void]
    def build_enumerator(before = Time.current.iso8601, cursor:)
      enumerator_builder.active_record_on_records(
        OrderingInvalidation.stale(before:),
        cursor:
      )
    end

    # @param [OrderingInvalidation] ordering_invalidation
    # @param [String] _before
    # @return [void]
    def each_iteration(ordering_invalidation, _before = Time.current.iso8601)
      ordering_invalidation.process!
    end
  end
end
