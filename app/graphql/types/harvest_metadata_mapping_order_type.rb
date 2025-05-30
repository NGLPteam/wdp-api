# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsHarvestMetadataMapping
  class HarvestMetadataMappingOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `HarvestMetadataMapping` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort harvest metadata mappings by their default order."
    end

    value "RECENT" do
      description "Sort harvest metadata mappings by newest created date."
    end

    value "OLDEST" do
      description "Sort harvest metadata mappings by oldest created date."
    end
  end
end
