# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateHarvestSource
    class MutateHarvestSource < MutationOperations::Contract
      json do
        required(:name).filled(:string)
        required(:base_url).filled(:string)
        required(:mapping_options).value(:hash)
        required(:read_options).value(:hash)
        optional(:description).maybe(:string)
      end

      rule(:base_url).validate(:url_format)
    end
  end
end
