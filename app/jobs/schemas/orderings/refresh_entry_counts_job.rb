# frozen_string_literal: true

module Schemas
  module Orderings
    # Refresh {OrderingEntryCount} and then recalculate initial orderings.
    #
    # For now, we just recalculate system-wide to ensure that derivations
    # are always up to date (unless a selection has been set). If performance
    # becomes an issue, we will revise this job to execute a more restrictive
    # query that only updates derivations.
    #
    # @see Schemas::Orderings::CalculateInitialJob
    class RefreshEntryCountsJob < ApplicationJob
      queue_as :orderings

      # @return [void]
      def perform
        OrderingEntryCount.refresh!

        Schemas::Orderings::CalculateInitialJob.perform_later
      end
    end
  end
end
