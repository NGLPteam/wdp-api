# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestSourceUpdate
    # @see Mutations::Operations::HarvestSourceUpdate
    class HarvestSourceUpdate < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
        required(:name).filled(:string)
        required(:base_url).filled(:string)
        optional(:description).maybe(:string)
      end
    end
  end
end
