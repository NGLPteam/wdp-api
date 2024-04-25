# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::Operations::ClearInitialOrdering
    class ClearInitialOrdering < MutationOperations::Contract
      json do
        required(:entity).filled(Support::Models::Types::Model)
      end

      rule(:entity).validate(:entity)
    end
  end
end
