# frozen_string_literal: true

module Schemas
  module Instances
    # Given a {HierarchicalEntity}, it will first populate then reset all orderings on it.
    #
    # @see Schemas::Instances::PopulateOrderings
    # @see Schemas::Orderings::Reset
    class ResetAllOrderingsJob < ApplicationJob
      queue_as :maintenance

      # @param [HierarchicalEntity] entity
      # @return [void]
      def perform(entity)
        call_operation! "schemas.instances.populate_orderings", entity

        entity.orderings.find_each do |ordering|
          call_operation! "schemas.orderings.reset", ordering
        end
      end
    end
  end
end
