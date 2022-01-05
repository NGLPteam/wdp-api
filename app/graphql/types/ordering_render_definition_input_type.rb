# frozen_string_literal: true

module Types
  # A GraphQL input type for {Schemas::Orderings::RenderDefinition}.
  class OrderingRenderDefinitionInputType < Types::BaseInputObject
    include AutoHash

    description <<~TEXT
    Describe how an ordering should render its entries.
    TEXT

    argument :mode, Types::OrderingRenderModeType, required: false, default_value: "flat", attribute: true
  end
end
