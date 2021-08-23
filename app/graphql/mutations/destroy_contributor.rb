# frozen_string_literal: true

module Mutations
  class DestroyContributor < Mutations::BaseMutation
    description <<~TEXT.strip_heredoc
    Destroy a contributor by ID.
    TEXT

    field :destroyed, Boolean, null: true

    argument :contributor_id, ID, loads: Types::AnyContributorType, required: true

    performs_operation! "mutations.operations.destroy_contributor"
  end
end
