# frozen_string_literal: true

module Schemas
  module Orderings
    # @see Schemas::Orderings::CalculateInitial
    class CalculateInitialJob < ApplicationJob
      queue_as :orderings

      unique_job! by: :first_arg

      # @return [void]
      def perform(**options)
        call_operation! "schemas.orderings.calculate_initial", **options
      end
    end
  end
end
