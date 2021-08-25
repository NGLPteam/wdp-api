# frozen_string_literal: true

module Types
  module StandardMutationPayload
    include Types::BaseInterface

    description "Most mutations implement this interface in their payload in order to offer a standardize response value"

    field :errors, [Types::UserError, { null: false }], null: false

    field :attribute_errors, [Types::MutationAttributeErrorType, { null: false }], null: false

    field :global_errors, [Types::MutationGlobalErrorType, { null: false }], null: false

    field :halt_code, String, null: true,
      description: "Not presently used"

    def attribute_errors
      object[:attribute_errors].map do |(path, type), messages|
        { path: path, type: type, messages: messages }
      end
    end
  end
end
