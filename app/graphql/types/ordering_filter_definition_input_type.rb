# frozen_string_literal: true

module Types
  # A GraphQL input type for {Schemas::Orderings::FilterDefinition}.
  class OrderingFilterDefinitionInputType < Types::BaseInputObject
    include AutoHash

    description <<~TEXT
    A collection of settings for filtering what appears what entities
    may populate an ordering. At present, this only supports schemas.
    TEXT

    argument :schemas, [Types::OrderingSchemaFilterInputType, { null: false }], required: false, attribute: true do
      description <<~TEXT
      If set, any child or descendant that matches one of these schemas will
      be availabel to be included in the ordering.
      TEXT
    end
  end
end
