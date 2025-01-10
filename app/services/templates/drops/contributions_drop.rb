# frozen_string_literal: true

module Templates
  module Drops
    # A drop that wraps around _all_ {Contribution}s.
    class ContributionsDrop < Templates::Drops::AbstractContributionsDrop
      private

      def fetch_contributions
        super.all
      end
    end
  end
end
