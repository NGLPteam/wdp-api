# frozen_string_literal: true

module Types
  # @see Templates::ContributionList
  # @see Templates::Definitions::HasContributionList
  # @see Templates::Instances::HasContributionList
  # @see Types::TemplateContributionListType
  module TemplateHasContributionListType
    include Types::BaseInterface

    description <<~TEXT
    An interface for a template instance that has a `TemplateContributionList`.
    TEXT

    field :contribution_list, ::Types::TemplateContributionListType, null: false do
      description <<~TEXT
      The list of contributions to render as part of this template's content.
      TEXT
    end
  end
end
