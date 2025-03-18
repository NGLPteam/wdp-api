# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestAttemptFromSource
    # @see Mutations::Operations::HarvestAttemptFromSource
    class HarvestAttemptFromSource < MutationOperations::Contract
      json do
        required(:harvest_source).value(:harvest_source)
        required(:target_entity).value(:harvest_target)
        required(:extraction_mapping_template).filled(:string)

        optional(:harvest_set).maybe(:harvest_set)
        optional(:description).maybe(:string)
      end

      rule(:extraction_mapping_template).validate(:harvest_extraction_mapping_template)
    end
  end
end
