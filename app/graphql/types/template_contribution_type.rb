# frozen_string_literal: true

module Types
  # @see Contribution
  # @see Types::ContributionBaseType
  # @see Types::ContributorBaseType
  # @see Types::TemplateContributionListType
  class TemplateContributionType < Types::BaseObject
    description <<~TEXT
    A contribution from a certain contributor.

    This is a pared-down version of `Contribution` in order to
    better support fragment caching and smaller queries.

    It uses `ContributorBase` in place of the `AnyContributor` union.
    TEXT

    implements Types::ContributionBaseType

    field :contributor, Types::ContributorBaseType, null: false do
      description <<~TEXT
      The contributor, loaded via abstract interface for simplicity.
      TEXT
    end
  end
end
