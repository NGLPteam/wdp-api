# frozen_string_literal: true

module Types
  class SchemaKindType < Types::BaseEnum
    value "COMMUNITY", value: "community"
    value "COLLECTION", value: "collection"
    value "ITEM", value: "item"
    value "METADATA", value: "metadata", description: "Presently unused"
  end
end
