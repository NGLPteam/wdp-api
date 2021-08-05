# frozen_string_literal: true

module Schemas
  module Instances
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
