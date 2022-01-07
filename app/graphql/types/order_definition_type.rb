# frozen_string_literal: true

module Types
  # A GraphQL type for a {Schemas::Orderings::OrderDefinition}.
  class OrderDefinitionType < Types::BaseObject
    description "Ordering for a specific column"

    field :path, String, null: false
    field :direction, Types::DirectionType, null: false
    field :nulls, Types::NullOrderPriorityType, null: false
  end
end
