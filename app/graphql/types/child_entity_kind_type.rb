# frozen_string_literal: true

module Types
  class ChildEntityKindType < Types::BaseEnum
    description <<~TEXT
    Child entity kind enum
    TEXT

    value "COLLECTION", value: "collection" do
      description <<~TEXT
      TEXT
    end

    value "ITEM", value: "item" do
      description <<~TEXT
      TEXT
    end
  end
end
