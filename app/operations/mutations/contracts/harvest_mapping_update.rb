# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestMappingUpdate
    # @see Mutations::Operations::HarvestMappingUpdate
    class HarvestMappingUpdate < MutationOperations::Contract
      json do
        required(:harvest_mapping).value(:harvest_mapping)
        required(:target_entity).value(:harvest_target)
      end
    end
  end
end
