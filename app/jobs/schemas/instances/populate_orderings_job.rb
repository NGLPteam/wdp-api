# frozen_string_literal: true

module Schemas
  module Instances
    # @see Schemas::Instances::PopulateOrderings
    class PopulateOrderingsJob < ApplicationJob
      queue_as :maintenance

      # @param [HierarchicalEntity] entity
      # @return [void]
      def perform(entity)
        call_operation! "schemas.instances.populate_orderings", entity
      end
    end
  end
end
