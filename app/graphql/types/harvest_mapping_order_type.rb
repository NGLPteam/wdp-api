# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsHarvestMapping
  class HarvestMappingOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `HarvestMapping` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort harvest mappings by their default order."
    end

    value "RECENT" do
      description "Sort harvest mappings by newest created date."
    end

    value "OLDEST" do
      description "Sort harvest mappings by oldest created date."
    end
  end
end
