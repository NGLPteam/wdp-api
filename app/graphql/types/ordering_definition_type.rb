# frozen_string_literal: true

module Types
  # The GraphQL representation of an {Ordering}.
  class OrderingDefinitionType < Types::BaseObject
    description <<~TEXT
    A definition for an ordering (may be dynamic).
    TEXT

    field :identifier, String, null: false do
      description "A unique identifier for the ordering within the context of its parent entity."
    end

    field :name, String, null: true do
      description "An optional, human-readable name for the ordering"
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

    field :filter, Types::OrderingFilterDefinitionType, null: false

    field :order, [Types::OrderDefinitionType, { null: false }], null: false

    field :render, Types::OrderingRenderDefinitionType, null: false do
      description <<~TEXT
      Configuration for how to render an ordering and its entries.
      TEXT
    end

    field :select, Types::OrderingSelectDefinitionType, null: false

    field :tree, Boolean, null: false, method: :tree_mode? do
      description <<~TEXT
      A tree ordering has some special handling to return entities
      in deterministic order based on their hierarchical position
      and relation to other entities in the same ordering.

      This is effectively a shortcut for `Ordering.render.mode === "TREE"`.
      TEXT
    end
  end
end
