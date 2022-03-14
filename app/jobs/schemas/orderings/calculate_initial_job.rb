# frozen_string_literal: true

module Schemas
  module Orderings
    # @see Schemas::Orderings::CalculateInitial
    class CalculateInitialJob < ApplicationJob
      queue_as :maintenance

      DO_NOTHING = proc { true }

      unique :until_and_while_executing, lock_ttl: 1.minute, on_conflict: DO_NOTHING

      # @return [void]
      def perform(**options)
        call_operation! "schemas.orderings.calculate_initial", **options
      end
    end
  end
end
