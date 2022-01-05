# frozen_string_literal: true

module Types
  # The GraphQL representation of an {Ordering}.
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

    field :constant, Boolean, null: false, method: :constant? do
      description "A constant ordering should be treated as not being able to invert itself."
    end

    field :hidden, Boolean, null: false, method: :hidden? do
      description <<~TEXT
      A hidden ordering represents an ordering that should not be shown in the frontend,
      when iterating over an entity's available orderings. It does not affect access, as
      hidden orderings may still serve a functional purpose for their schema.
      TEXT
    end

    field :render, Types::OrderingRenderDefinitionType, null: false do
      description <<~TEXT
      Configuration for how to render an ordering and its entries.
      TEXT
    end

    field :tree, Boolean, null: false, method: :tree_mode? do
      description <<~TEXT
      A tree ordering has some special handling to return entities
      in deterministic order based on their hierarchical position
      and relation to other entities in the same ordering.

      This is effectively a shortcut for `Ordering.render.mode === "TREE"`.
      TEXT
    end

    # @see Schemas::Orderings::Definition#render
    # @return [Schemas::Orderings::RenderDefinition]
    def render
      object.definition.render
    end
  end
end
