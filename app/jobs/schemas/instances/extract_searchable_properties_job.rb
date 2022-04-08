# frozen_string_literal: true

module Schemas
  module Instances
    class ExtractSearchablePropertiesJob < ApplicationJob
      queue_as :maintenance

      # @param [HierarchicalEntity] entity
      # @return [void]
      def perform(entity)
        call_operation! "schemas.instances.extract_searchable_properties", entity
      end
    end
  end
end
