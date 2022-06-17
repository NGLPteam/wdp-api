# frozen_string_literal: true

module Mutations
  module Shared
    # Include this module in a mutation that should make sure
    # any orderings are refreshed asynchronously.
    #
    # @see Schemas::Orderings::RefreshStatus
    module RefreshesOrderingsAsynchronously
      extend ActiveSupport::Concern

      included do
        around_execution :with_async_ordering_refresh
      end

      # @see Schemas::Orderings.with_asynchronous_refresh
      # @return [void]
      def with_async_ordering_refresh
        Schemas::Orderings.with_asynchronous_refresh do
          yield
        end
      end
    end
  end
end
