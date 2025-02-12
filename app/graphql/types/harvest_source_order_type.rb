# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsHarvestSource
  class HarvestSourceOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `HarvestSource` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort harvest sources by their default order."
    end

    value "RECENT" do
      description "Sort harvest sources by newest created date."
    end

    value "OLDEST" do
      description "Sort harvest sources by oldest created date."
    end
  end
end
