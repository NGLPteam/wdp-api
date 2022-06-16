# frozen_string_literal: true

module Mutations
  class UpdateContribution < Mutations::BaseMutation
    description <<~TEXT
    Update a Contribution by ID.
    TEXT

    field :contribution, Types::AnyContributionType, null: true

    argument :contribution_id, ID, loads: Types::ContributionType, required: true

    argument :role, String, required: false, description: "An arbitrary text value that describes the kind of contribution"
    argument :metadata, Types::ContributionMetadataInputType, required: false

    performs_operation! "mutations.operations.update_contribution"
  end
end
