# frozen_string_literal: true

module Schemas
  module Orderings
    # Refresh {OrderingEntryCount}.
    class RefreshEntryCountsJob < ApplicationJob
      queue_as :maintenance

      # @return [void]
      def perform
        OrderingEntryCount.refresh!
      end
    end
  end
end
