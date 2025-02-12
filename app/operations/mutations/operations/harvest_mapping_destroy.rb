# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestMappingDestroy
    class HarvestMappingDestroy
      include MutationOperations::Base

      authorizes! :harvest_mapping, with: :destroy?

      use_contract! :harvest_mapping_destroy

      # @param [HarvestMapping] harvest_mapping
      # @return [void]
      def call(harvest_mapping:)
        destroy_model! harvest_mapping, auth: true
      end
    end
  end
end
