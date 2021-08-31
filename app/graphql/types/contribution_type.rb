# frozen_string_literal: true

module Types
  module ContributionType
    include Types::BaseInterface

    description "A contribution from a certain contributor"

    field :contributor, "Types::AnyContributorType", null: false

    field :contributor_kind, Types::ContributorKindType, null: false

    field :metadata, Types::ContributionMetadataType, null: false

    field :role, String, null: true, description: "An arbitrary text value describing the role the contributor had"

    field :display_name, String, null: false, description: "A potentially-overridden display name value for all contributor types"

    field :title, String, null: true, description: "A potentially-overridden value from person contributors"

    field :affiliation, String, null: true, description: "A potentially-overridden value from person contributors"

    field :location, String, null: true, description: "A potentially-overridden value from organization contributors"
  end
end
