# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsControlledVocabulary
  class ControlledVocabularyOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `ControlledVocabulary` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort controlled vocabularies by their default order."
    end

    value "RECENT" do
      description "Sort controlled vocabularies by newest created date."
    end

    value "OLDEST" do
      description "Sort controlled vocabularies by oldest created date."
    end
  end
end
