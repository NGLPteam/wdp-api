# frozen_string_literal: true

module Mutations
  class UpsertContribution < Mutations::BaseMutation
    description <<~TEXT
    Upsert a Contribution by contributable & contributor ID. It will override any
    existing contributions for the same contributor on the same entity.
    TEXT

    field :contribution, Types::AnyContributionType, null: true

    argument :contributable_id, ID, loads: Types::ContributableType, required: true
    argument :contributor_id, ID, loads: Types::AnyContributorType, required: true

    argument :role_id, ID, loads: Types::ControlledVocabularyItemType, required: false,
      description: "If not provided, it will use the default role."

    argument :role, String, as: :deprecated_role, required: false, transient: true, description: "An arbitrary text value that describes the kind of contribution",
      deprecation_reason: "No longer used"

    argument :metadata, Types::ContributionMetadataInputType, required: false do
      description <<~TEXT
      Metadata for the contribution. If not provided, it will keep whatever is there.
      TEXT
    end

    argument :position, Int, required: false do
      description <<~TEXT
      Sorting discriminator for the contribution. If not provided, it will keep whatever is there.
      TEXT
    end

    performs_operation! "mutations.operations.upsert_contribution"
  end
end
