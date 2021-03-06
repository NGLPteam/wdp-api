# frozen_string_literal: true

module Mutations
  class UpdateOrdering < Mutations::BaseMutation
    description "Update an ordering by ID"

    field :ordering, Types::OrderingType, null: true, description: "The updated ordering"

    argument :ordering_id, ID, loads: Types::OrderingType, required: true do
      description <<~TEXT
      The ID for the ordering to update
      TEXT
    end

    argument :name, String, required: false, attribute: true do
      description "A human readable label for the ordering"
    end

    argument :header, String, required: false, attribute: true do
      description "Optional markdown content to display before the ordering's children"
    end

    argument :footer, String, required: false, attribute: true do
      description "Optional markdown content to display after the ordering's children"
    end

    argument :filter, Types::OrderingFilterDefinitionInputType, required: false, attribute: true

    argument :select, Types::OrderingSelectDefinitionInputType, required: false, attribute: true

    argument :order, [Types::OrderDefinitionInputType, { null: false }], required: true, attribute: true

    argument :render, Types::OrderingRenderDefinitionInputType, required: false, attribute: true

    performs_operation! "mutations.operations.update_ordering"
  end
end
