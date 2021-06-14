# frozen_string_literal: true

module Types
  class EntityKindType < Types::BaseEnum
    description "An enumeration of the different kinds of hierarchical entities"

    value "COMMUNITY", value: "Community"
    value "COLLECTION", value: "Collection"
    value "ITEM", value: "Item"
  end
end
