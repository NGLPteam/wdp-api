# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsControlledVocabularySource
  class ControlledVocabularySourceOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `ControlledVocabularySource` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort controlled vocabulary sources by their default order."
    end

    value "RECENT" do
      description "Sort controlled vocabulary sources by newest created date."
    end

    value "OLDEST" do
      description "Sort controlled vocabulary sources by oldest created date."
    end
  end
end
