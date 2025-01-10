# frozen_string_literal: true

module Templates
  module Drops
    # A drop that wraps around _only_ author {Contribution}s.
    class AuthorsDrop < Templates::Drops::AbstractContributionsDrop
      private

      def fetch_contributions
        super.authors
      end
    end
  end
end
