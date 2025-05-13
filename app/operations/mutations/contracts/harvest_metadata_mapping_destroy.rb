# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestMetadataMappingDestroy
    # @see Mutations::Operations::HarvestMetadataMappingDestroy
    class HarvestMetadataMappingDestroy < MutationOperations::Contract
      json do
        required(:harvest_metadata_mapping).value(:harvest_metadata_mapping)
      end
    end
  end
end
