# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestAttemptFromSource
    # @see Mutations::Operations::HarvestAttemptFromSource
    class HarvestAttemptFromSource < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
      end

      rule do
        base.failure(:not_yet_implemented)
      end
    end
  end
end
