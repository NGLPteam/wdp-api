# frozen_string_literal: true

module Schemas
  module Orderings
    # @see Schemas::Orderings::CalculateInitial
    class CalculateInitialJob < ApplicationJob
      queue_as :orderings

      unique :until_and_while_executing, lock_ttl: 1.minute, runtime_lock_ttl: 1.minute, on_conflict: :log,
        on_runtime_conflict: :log

      # @return [void]
      def perform(**options)
        call_operation! "schemas.orderings.calculate_initial", **options
      end
    end
  end
end
