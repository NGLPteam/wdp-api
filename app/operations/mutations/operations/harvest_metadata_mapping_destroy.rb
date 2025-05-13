# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestMetadataMappingDestroy
    class HarvestMetadataMappingDestroy
      include MutationOperations::Base

      use_contract! :harvest_metadata_mapping_destroy

      # @param [HarvestMetadataMapping] harvest_metadata_mapping
      # @return [void]
      def call(harvest_metadata_mapping:)
        destroy_model! harvest_metadata_mapping, auth: true
      end
    end
  end
end
