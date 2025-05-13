# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestMetadataMappingCreate
    # @see Mutations::Operations::HarvestMetadataMappingCreate
    class HarvestMetadataMappingCreate < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
        required(:field).value(:harvest_metadata_mapping_field)
        required(:pattern).filled(:string)
        required(:target_entity).value(:harvest_target)
      end
    end
  end
end
