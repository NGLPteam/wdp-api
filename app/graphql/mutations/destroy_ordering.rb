# frozen_string_literal: true

module Mutations
  class DestroyOrdering < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Destroy (or disable a schema-inherited) ordering.
    TEXT

    field :disabled, Boolean, null: true

    argument :ordering_id, ID, loads: Types::OrderingType, required: true

    performs_operation! "mutations.operations.destroy_ordering", destroy: true
  end
end
