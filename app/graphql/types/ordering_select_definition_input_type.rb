# frozen_string_literal: true

module Types
  # A GraphQL input type for {Schemas::Orderings::SelectDefinition}.
  class OrderingSelectDefinitionInputType < Types::BaseInputObject
    include AutoHash

    description <<~TEXT
    Define how an ordering should select its entries
    TEXT

    argument :direct, Types::OrderingDirectSelectionType, required: false, default_value: "children", attribute: true

    argument :links, Types::OrderingSelectLinkDefinitionInputType, required: false, attribute: true
  end
end
