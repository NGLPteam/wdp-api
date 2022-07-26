# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::Operations::SelectInitialOrdering
    class SelectInitialOrdering < MutationOperations::Contract
      json do
        required(:entity).filled(Models::Types::Model)
        required(:ordering).value(AppTypes::Instance(::Ordering))
      end

      rule(:entity).validate(:entity)

      rule(:ordering) do
        key.failure(:must_not_be_disabled) if value.disabled?
      end

      rule(:ordering, :entity) do
        next if rule_error?(:ordering) || rule_error?(:entity)

        key(:ordering).failure(:must_be_associated_with_entity) unless values[:ordering].entity == values[:entity]
      end
    end
  end
end
