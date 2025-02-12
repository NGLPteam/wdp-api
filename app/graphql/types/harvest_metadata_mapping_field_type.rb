# frozen_string_literal: true

module Types
  class HarvestMetadataMappingFieldType < Types::BaseEnum
    description <<~TEXT
    Harvest metadata mapping field enum
    TEXT

    value "RELATION", value: "relation" do
      description <<~TEXT
      TEXT
    end

    value "TITLE", value: "title" do
      description <<~TEXT
      TEXT
    end

    value "IDENTIFIER", value: "identifier" do
      description <<~TEXT
      TEXT
    end
  end
end
