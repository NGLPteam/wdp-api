# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateHarvestMapping
    class MutateHarvestMapping < MutationOperations::Contract
      json do
        required(:mapping_options).value(:hash)
        required(:read_options).value(:hash)
        required(:extraction_mapping_template).filled(:string)

        optional(:frequency_expression).maybe(:string)
      end

      rule(:extraction_mapping_template).validate(:harvest_extraction_mapping_template)
      rule(:frequency_expression).validate(:harvest_frequency_expression)
    end
  end
end
