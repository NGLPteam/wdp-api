# frozen_string_literal: true

module Types
  class HarvestMetadataMappingFieldType < Types::BaseEnum
    description <<~TEXT
    An enum describing which "field" to match on. An individual record
    can try to match any number of fields in order to satisfy its mappings.
    TEXT

    value "IDENTIFIER", value: "identifier" do
      description <<~TEXT
      Some sort of identifier for the record itself.
      TEXT
    end

    value "RELATION", value: "relation" do
      description <<~TEXT
      Some sort of relationship identifier for the record.
      TEXT
    end

    value "TITLE", value: "title" do
      description <<~TEXT
      An attempt to map records based on their title value(s) to existing collections.
      TEXT
    end
  end
end
