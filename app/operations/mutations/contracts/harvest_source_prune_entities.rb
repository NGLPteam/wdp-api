# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestSourcePruneEntities
    # @see Mutations::Operations::HarvestSourcePruneEntities
    class HarvestSourcePruneEntities < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
      end
    end
  end
end
