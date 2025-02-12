# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestMappingDestroy
    # @see Mutations::Operations::HarvestMappingDestroy
    class HarvestMappingDestroy < MutationOperations::Contract
      json do
        required(:harvest_mapping).value(:harvest_mapping)
      end
    end
  end
end
