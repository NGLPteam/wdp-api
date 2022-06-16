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

    argument :role, String, required: false, description: "An arbitrary text value that describes the kind of contribution"
    argument :metadata, Types::ContributionMetadataInputType, required: false

    performs_operation! "mutations.operations.upsert_contribution"
  end
end
