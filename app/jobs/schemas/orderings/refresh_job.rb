# frozen_string_literal: true

module Schemas
  module Orderings
    # @see Schemas::Orderings::Refresh
    class RefreshJob < ApplicationJob
      queue_as :orderings

      unique_job! by: :first_arg

      # @param [Ordering] ordering
      # @return [void]
      def perform(ordering)
        call_operation! "schemas.orderings.refresh", ordering
      end
    end
  end
end
