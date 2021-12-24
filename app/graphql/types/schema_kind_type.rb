# frozen_string_literal: true

module Types
  class SchemaKindType < Types::BaseEnum
    description "The kind of entity a schema applies to"

    value "COMMUNITY", value: "community"
    value "COLLECTION", value: "collection"
    value "ITEM", value: "item"
  end
end
