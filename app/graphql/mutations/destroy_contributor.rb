# frozen_string_literal: true

module Mutations
  class DestroyContributor < Mutations::BaseMutation
    description <<~TEXT
    Destroy a contributor by ID.
    TEXT

    argument :contributor_id, ID, loads: Types::AnyContributorType, required: true

    performs_operation! "mutations.operations.destroy_contributor", destroy: true
  end
end
