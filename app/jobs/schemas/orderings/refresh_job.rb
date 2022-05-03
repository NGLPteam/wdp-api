# frozen_string_literal: true

module Schemas
  module Orderings
    # @see Schemas::Orderings::Refresh
    class RefreshJob < ApplicationJob
      queue_as :orderings

      unique :until_and_while_executing, lock_ttl: 1.hour, runtime_lock_ttl: 1.minute, on_conflict: :log,
        on_runtime_conflict: :log

      # @param [Ordering] ordering
      # @return [void]
      def perform(ordering)
        call_operation! "schemas.orderings.refresh", ordering
      end
    end
  end
end
