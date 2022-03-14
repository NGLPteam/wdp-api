# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::SelectInitialOrdering
  class SelectInitialOrdering < Mutations::BaseMutation
    description <<~TEXT
    Specify the initial ordering for a specific entity, rather than falling back
    to the default derivation.
    TEXT

    field :entity, Types::AnyEntityType, null: true
    field :ordering, Types::OrderingType, null: true

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true, attribute: true
    argument :ordering_id, ID, loads: Types::OrderingType, required: true, attribute: true

    performs_operation! "mutations.operations.select_initial_ordering"
  end
end
