# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsHarvestRecord
  class HarvestRecordOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `HarvestRecord` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort harvest records by their default order."
    end

    value "RECENT" do
      description "Sort harvest records by newest created date."
    end

    value "OLDEST" do
      description "Sort harvest records by oldest created date."
    end
  end
end
