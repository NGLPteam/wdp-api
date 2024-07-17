# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsControlledVocabularyItem
  class ControlledVocabularyItemOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `ControlledVocabularyItem` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort controlled vocabulary items by their default order."
    end

    value "RECENT" do
      description "Sort controlled vocabulary items by newest created date."
    end

    value "OLDEST" do
      description "Sort controlled vocabulary items by oldest created date."
    end
  end
end
