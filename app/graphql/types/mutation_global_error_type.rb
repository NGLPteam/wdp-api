# frozen_string_literal: true

module Types
  class MutationGlobalErrorType < Types::BaseObject
    description "An error that encapsulates the entire mutation input and is not tied to a specific input field."

    field :type, String, null: false

    field :message, String, null: false, description: "The actual message"
  end
end
