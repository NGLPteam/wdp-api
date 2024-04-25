# frozen_string_literal: true

module Types
  module StandardMutationPayload
    include Types::BaseInterface

    description "Most mutations implement this interface in their payload in order to offer a standardize response value"

    field :attribute_errors, [Types::MutationAttributeErrorType, { null: false }], null: false

    field :global_errors, [Types::MutationGlobalErrorType, { null: false }], null: false

    field :halt_code, String, null: true,
      description: "Not presently used"

    field :errors, [Types::UserError, { null: false }], null: false, deprecation_reason: "Use attributeErrors or globalErrors"

    def attribute_errors
      object[:attribute_errors].map do |(path, type), messages|
        { path:, type:, messages: }
      end
    end
  end
end
