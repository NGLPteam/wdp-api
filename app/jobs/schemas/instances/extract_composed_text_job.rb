# frozen_string_literal: true

module Schemas
  module Instances
    class ExtractComposedTextJob < ApplicationJob
      queue_as :maintenance

      # @param [HierarchicalEntity] entity
      # @return [void]
      def perform(entity)
        call_operation! "schemas.instances.extract_composed_text", entity
      end
    end
  end
end
