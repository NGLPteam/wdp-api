# frozen_string_literal: true

module Mutations
  class UpdateContribution < Mutations::BaseMutation
    description <<~TEXT
    Update a Contribution by ID.

    **Note**: Neither the contribution role nor the contributor can be changed
    by this mutation. Rather than deal with uniqueness violations, it's necessary
    to delete the old contribution and create a new one with the correct role
    or contributor.
    TEXT

    field :contribution, Types::AnyContributionType, null: true

    argument :contribution_id, ID, loads: Types::ContributionType, required: true

    argument :role, String, required: false, as: :deprecated_role, description: "An arbitrary text value that describes the kind of contribution",
      deprecation_reason: "No longer used"

    argument :metadata, Types::ContributionMetadataInputType, required: false do
      description <<~TEXT
      Metadata for the contribution. If not provided, it will keep whatever is there.
      TEXT
    end

    argument :outer_position, Int, required: false do
      description <<~TEXT
      "Outer" sorting discriminator for the contribution. If not provided, it will keep whatever is there.

      It applies _before_ the contribution role.
      TEXT
    end

    argument :inner_position, Int, required: false do
      description <<~TEXT
      "Inner" sorting discriminator for the contribution. If not provided, it will keep whatever is there.

      It applies _after_ the contribution role.
      TEXT
    end

    performs_operation! "mutations.operations.update_contribution"
  end
end
