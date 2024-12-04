# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::ContributionList
    # @see Templates::Instances::FetchContributionList
    # @see Templates::Instances::ContributionListFetcher
    # @see Templates::Instances::HasContributionList
    # @see Types::TemplateContributionListType
    # @see Types::TemplateHasContributionListType
    module HasContributionList
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation
    end
  end
end
