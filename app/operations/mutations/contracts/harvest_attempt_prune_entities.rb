# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestAttemptPruneEntities
    # @see Mutations::Operations::HarvestAttemptPruneEntities
    class HarvestAttemptPruneEntities < MutationOperations::Contract
      json do
        required(:harvest_attempt).value(:harvest_attempt)
      end
    end
  end
end
