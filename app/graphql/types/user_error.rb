# frozen_string_literal: true

module Types
  class UserError < Types::BaseObject
    description "A user-readable error. Somewhat deprecated now, but may be repurposed"

    field :message, String, null: false,
      description: "A description of the error"

    field :code, String, null: true

    field :path, [String], null: true,
      description: "Which input value this error came from"

    field :attribute_path, String, null: true,
      description: "The attribute path to this error, if applicable"

    field :scope, Types::MutationErrorScopeType, null: false,
      description: "Whether this error applies to a single attribute, or globally to the entire form"
  end
end
