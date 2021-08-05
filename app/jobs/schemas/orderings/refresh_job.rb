# frozen_string_literal: true

module Schemas
  module Orderings
    class RefreshJob < ApplicationJob
      queue_as :maintenance

      unique :until_and_while_executing, lock_ttl: 5.minutes, on_conflict: :log

      # @param [Ordering] ordering
      # @return [void]
      def perform(ordering)
        call_operation! "schemas.orderings.refresh", ordering
      end
    end
  end
end
