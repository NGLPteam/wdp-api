# frozen_string_literal: true

module Types
  # @see Contribution
  # @see Types::ContributionType
  # @see Types::TemplateContributionType
  # @see Types::CollectionContributionType
  # @see Types::ItemContributionType
  module ContributionBaseType
    include Types::BaseInterface

    description <<~TEXT
    An interface representing a contribution from a certain contributor.

    It leaves the `contributor` field's implementation up to later
    implementations, as we have different needs elsewhere in the API.

    See `Contribution` and `TemplateContribution`.
    TEXT

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
