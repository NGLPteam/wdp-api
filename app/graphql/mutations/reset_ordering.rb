# frozen_string_literal: true

module Mutations
  class ResetOrdering < Mutations::BaseMutation
    description <<~TEXT
    Reset an ordering to "factory" settings. For schema-inherited orderings,
    this will reload its definition from the schema definition. For custom
    orderings, this will load minimal defaults.
    TEXT

    field :ordering, Types::OrderingType, null: true

    argument :ordering_id, ID, loads: Types::OrderingType, required: true

    performs_operation! "mutations.operations.reset_ordering"
  end
end
