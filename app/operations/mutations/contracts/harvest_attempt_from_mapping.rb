# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestAttemptFromMapping
    # @see Mutations::Operations::HarvestAttemptFromMapping
    class HarvestAttemptFromMapping < MutationOperations::Contract
      json do
        required(:harvest_mapping).value(:harvest_mapping)
      end

      rule do
        base.failure(:not_yet_implemented)
      end
    end
  end
end
