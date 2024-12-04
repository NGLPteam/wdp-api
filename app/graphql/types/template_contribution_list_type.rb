# frozen_string_literal: true

module Types
  # @see Templates::ContributionList
  # @see Templates::Definitions::HasContributionList
  # @see Templates::Instances::HasContributionList
  # @see Types::TemplateHasContributionListType
  class TemplateContributionListType < Types::BaseObject
    description <<~TEXT
    `ContributorListTemplateInstance`s return an ordered list of contributions to render
    within as part of their content.
    TEXT

    field :count, Int, null: false do
      description <<~TEXT
      The size of the list.
      TEXT
    end

    field :empty, Boolean, null: false do
      description <<~TEXT
      Whether the list is empty, provided for easier filtering and render-skipping.
      TEXT
    end

    field :contributions, [::Types::TemplateContributionType, { null: false }], null: false, method: :valid_contributions do
      description <<~TEXT
      The actual entity records within this list.

      The order is deterministic.
      TEXT
    end
  end
end
