# frozen_string_literal: true

module Schemas
  module Orderings
    class ResetJob < ApplicationJob
      queue_as :orderings

      unique :until_and_while_executing, lock_ttl: 5.minutes, on_conflict: :log

      # @param [Ordering] ordering
      # @return [void]
      def perform(ordering)
        call_operation! "schemas.orderings.reset", ordering
      end
    end
  end
end
