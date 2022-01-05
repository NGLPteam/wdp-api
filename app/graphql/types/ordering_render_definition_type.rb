# frozen_string_literal: true

module Types
  # @see Schemas::Orderings::RenderDefinition
  class OrderingRenderDefinitionType < Types::BaseObject
    description <<~TEXT
    Configuration for controlling how an ordering renders itself and its entries.
    TEXT

    field :mode, Types::OrderingRenderModeType, null: false,
      description: "How to render entries within"
  end
end
