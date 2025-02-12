# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestMappingCreate
    # @see Mutations::Operations::HarvestMappingCreate
    class HarvestMappingCreate < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
        required(:target_entity).value(:harvest_target)
        required(:metadata_format).filled(:harvest_metadata_format)

        optional(:harvest_set).maybe(:harvest_set)
      end
    end
  end
end
