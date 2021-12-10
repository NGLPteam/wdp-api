# frozen_string_literal: true

module Types
  class VariablePrecisionDateInputType < Types::BaseInputObject
    description <<~TEXT
    A corresponding input type for VariablePrecisionDate.
    TEXT

    argument :value, GraphQL::Types::ISO8601Date, required: false,
      description: "The actual date, encoded in ISO8601 format (if available)"

    argument :precision, Types::DatePrecisionType, required: true,
      description: "The level of precision: the frontend can make decisions about how to format the associated value based on this"

    def prepare
      to_h
    end
  end
end
