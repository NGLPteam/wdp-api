# frozen_string_literal: true

module Mutations
  class CreateOrdering < Mutations::BaseMutation
    description "Create an ordering for an entity"

    field :ordering, Types::OrderingType, null: true, description: "The created ordering"

    argument :entity_id, ID, loads: Types::AnyEntityType, required: true do
      description <<~TEXT
      The entity to create the ordering for.
      TEXT
    end

    argument :identifier, String, required: true, attribute: true do
      description "A unique (within the context of the entity) identifier. Cannot be changed"
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

    performs_operation! "mutations.operations.create_ordering"
  end
end
