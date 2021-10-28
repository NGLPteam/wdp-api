# frozen_string_literal: true

module Types
  class VariablePrecisionDateType < Types::BaseObject
    description <<~TEXT
    A wrapper around a date that allows us to describe a level of precision to apply to it,
    which can be used in the frontend to affect its display.
    TEXT

    field :value, GraphQL::Types::ISO8601Date, null: true,
      description: "The actual date, encoded in ISO8601 format (if available)"

    field :precision, Types::DatePrecisionType, null: false,
      description: "The level of precision: the frontend can make decisions about how to format the associated value based on this"
  end
end
