# frozen_string_literal: true

module Types
  # A GraphQL type for {Schemas::Orderings::SelectLinkDefinition}.
  class OrderingSelectLinkDefinitionType < Types::BaseObject
    description <<~TEXT
    Describes how an ordering should select its links.
    TEXT

    field :contains, Boolean, null: false
    field :references, Boolean, null: false
  end
end
