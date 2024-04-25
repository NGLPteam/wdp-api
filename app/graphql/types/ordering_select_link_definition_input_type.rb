# frozen_string_literal: true

module Types
  # A GraphQL input type for {Schemas::Orderings::SelectLinkDefinition}.
  class OrderingSelectLinkDefinitionInputType < Types::HashInputObject
    description <<~TEXT
    Describe how an ordering should select its links.
    TEXT

    argument :contains, Boolean, required: false, attribute: true
    argument :references, Boolean, required: false, attribute: true
  end
end
