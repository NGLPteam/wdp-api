# frozen_string_literal: true

module Templates
  module Drops
    # A drop that wraps around a {::Contribution}.
    class ContributionDrop < Templates::Drops::AbstractDrop
      # @return [String]
      attr_reader :affiliation

      # @return [String]
      attr_reader :display_name

      alias to_s display_name

      # @return [String]
      attr_reader :location

      # @return [String]
      attr_reader :title

      # @param [::Contribution, CollectionContribution, ItemContribution] contribution
      def initialize(contribution)
        super()

        @contribution = contribution

        @affiliation = contribution.affiliation
        @display_name = contribution.display_name
        @location = contribution.location
        @title = contribution.title
      end
    end
  end
end
