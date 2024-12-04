# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::ContributionListFetcher
    class FetchContributionList < Support::SimpleServiceOperation
      service_klass Templates::Instances::ContributionListFetcher
    end
  end
end
