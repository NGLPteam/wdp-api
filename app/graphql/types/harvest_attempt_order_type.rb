# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsHarvestAttempt
  class HarvestAttemptOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `HarvestAttempt` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort harvest attempts by their default order."
    end

    value "RECENT" do
      description "Sort harvest attempts by newest created date."
    end

    value "OLDEST" do
      description "Sort harvest attempts by oldest created date."
    end
  end
end
