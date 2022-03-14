# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::SelectInitialOrdering
  class ClearInitialOrdering < Mutations::BaseMutation
    description <<~TEXT
    Clear any previously manually-set initial orderings for the entity.

    This mutation is safe to call if none have been set previously,
    it will just be a no-op in that case.
    TEXT

    field :entity, Types::AnyEntityType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true, attribute: true

    performs_operation! "mutations.operations.clear_initial_ordering"
  end
end
