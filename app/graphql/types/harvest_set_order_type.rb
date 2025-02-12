# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsHarvestSet
  class HarvestSetOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `HarvestSet` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort harvest sets by their default order."
    end

    value "RECENT" do
      description "Sort harvest sets by newest created date."
    end

    value "OLDEST" do
      description "Sort harvest sets by oldest created date."
    end
  end
end
