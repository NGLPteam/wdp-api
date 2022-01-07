# frozen_string_literal: true

module Types
  # A GraphQL type for {Schemas::Orderings::SelectDefinition}.
  class OrderingSelectDefinitionType < Types::BaseObject
    description <<~TEXT
    Defines how an ordering should select its entries.
    TEXT

    field :direct, Types::OrderingDirectSelectionType, null: false

    field :links, Types::OrderingSelectLinkDefinitionType, null: false
  end
end
