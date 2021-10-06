# frozen_string_literal: true

module Types
  class SchemaInstanceValidationType < Types::BaseObject
    field :errors, [Types::SchemaValueErrorType, { null: false }], null: false
    field :valid, Boolean, null: false
    field :validated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
