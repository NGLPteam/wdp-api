# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestSourceDestroy
    # @see Mutations::Operations::HarvestSourceDestroy
    class HarvestSourceDestroy < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
      end
    end
  end
end
