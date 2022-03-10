# frozen_string_literal: true

module Schemas
  module Orderings
    class RefreshJob < ApplicationJob
      queue_as :maintenance

      DO_NOTHING = proc { true }

      unique :while_executing, lock_ttl: 1.minute, on_conflict: DO_NOTHING

      # @param [Ordering] ordering
      # @return [void]
      def perform(ordering)
        call_operation! "schemas.orderings.refresh", ordering
      end
    end
  end
end
