# frozen_string_literal: true

module Schemas
  module Instances
    # @see Schemas::Instances::ExtractCoreTexts
    class ExtractCoreTextsJob < ApplicationJob
      queue_as :maintenance

      # @param [HierarchicalEntity] entity
      # @return [void]
      def perform(entity)
        call_operation! "schemas.instances.write_core_texts", entity
      end
    end
  end
end
