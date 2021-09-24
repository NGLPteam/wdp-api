# frozen_string_literal: true

module Types
  class SchemaValueErrorType < Types::BaseObject
    description "An error that stems from trying to apply an invalid schema value."

    field :base, Boolean, null: false,
      description: "An error with the entire set of values",
      deprecation_reason: "Not presently used: see globalErrors"

    field :hint, Boolean, null: false,
      description: "Whether this is a hint"

    field :path, String, null: false,
      description: "Which input value this error came from"

    field :message, String, null: false,
      description: "A human-readable description of the error"

    field :metadata, GraphQL::Types::JSON, null: true,
      description: "Additional metadata attached to the error"
  end
end
