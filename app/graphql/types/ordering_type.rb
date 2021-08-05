# frozen_string_literal: true

module Types
  class OrderingType < Types::AbstractModel
    description "An ordering that belongs to an entity and arranges its children in a pre-configured way"

    field :entity, Types::AnyEntityType, null: false do
      description "The entity that owns the ordering"
    end

    field :children, resolver: Resolvers::OrderingEntryResolver

    field :identifier, String, null: false do
      description "A unique identifier for the ordering within the context of its parent entity."
    end

    field :disabled, Boolean, null: false, method: :disabled? do
      description "Whether the ordering has been disabled—orderings inherited from schemas will be disabled if deleted."
    end

    field :disabled_at, GraphQL::Types::ISO8601Date, null: true do
      description "The time the ordering was disabled, if applicable"
    end

    field :inherited_from_schema, Boolean, null: false do
      description "Whether the ordering was inherited from its entity's schema definition"
    end

    field :name, String, null: true do
      description "An optional, human-readable name for the ordering"
    end

    field :header, String, null: true do
      description "Optional markdown content to render before the children"
    end

    field :footer, String, null: true do
      description "Optional markdown content to render after the children"
    end
  end
end
