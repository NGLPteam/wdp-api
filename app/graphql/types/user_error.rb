# frozen_string_literal: true

module Types
  class UserError < Types::BaseObject
    description "A user-readable error"

    field :message, String, null: false,
      description: "A description of the error"

    field :code, String, null: true

    field :path, [String], null: true,
      description: "Which input value this error came from"
  end
end
