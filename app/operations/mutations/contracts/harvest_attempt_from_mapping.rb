# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestAttemptFromMapping
    # @see Mutations::Operations::HarvestAttemptFromMapping
    class HarvestAttemptFromMapping < MutationOperations::Contract
      json do
        required(:harvest_mapping).value(:harvest_mapping)
        required(:extraction_mapping_template).filled(:string)
        optional(:description).maybe(:string)
      end
    end
  end
end
