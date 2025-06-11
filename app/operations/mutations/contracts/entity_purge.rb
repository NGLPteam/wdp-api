# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::EntityPurge
    # @see Mutations::Operations::EntityPurge
    class EntityPurge < MutationOperations::Contract
      json do
        required(:entity).value(:any_entity)
      end
    end
  end
end
