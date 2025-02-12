# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateHarvestMapping
    class MutateHarvestMapping < MutationOperations::Contract
      json do
        required(:mapping_options).value(:hash)
        required(:read_options).value(:hash)
      end
    end
  end
end
