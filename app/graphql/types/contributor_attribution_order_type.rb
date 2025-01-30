# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsContributorAttribution
  class ContributorAttributionOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `ContributorAttribution` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Currently the same behavior as `TITLE_ASCENDING`."
    end

    value "PUBLISHED_ASCENDING" do
      description "Order by the associated entity's published date in ascending order."
    end

    value "PUBLISHED_DESCENDING" do
      description "Order by the associated entity's published date in descending order."
    end

    value "TITLE_ASCENDING" do
      description "Order by the associated entity's title in ascending order."
    end

    value "TITLE_DESCENDING" do
      description "Order by the associated entity's title in descending order."
    end

    value "RECENT" do
      description "Sort contributor attributions by newest created date."
    end

    value "OLDEST" do
      description "Sort contributor attributions by oldest created date."
    end
  end
end
