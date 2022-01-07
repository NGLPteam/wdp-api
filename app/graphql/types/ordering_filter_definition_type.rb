# frozen_string_literal: true

module Types
  # A GraphQL type for {Schemas::Orderings::FilterDefinition}.
  class OrderingFilterDefinitionType < Types::BaseObject
    description <<~TEXT
    A collection of settings for filtering what appears what entities
    may populate an ordering. At present, this only supports schemas.
    TEXT

    field :schemas, [Types::OrderingSchemaFilterType, { null: false }], null: false do
      description <<~TEXT
      If set, any child or descendant that matches one of these schemas will
      be availabel to be included in the ordering.
      TEXT
    end
  end
end
