# frozen_string_literal: true

module Types
  class AccessGrantEntityFilterType < Types::BaseEnum
    description "Filters a set of access grants by what type of entity they've granted access to"

    value "ALL", description: "All entity types"
    value "COMMUNITY", description: "Communities only"
    value "COLLECTION", description: "Collections only"
    value "ITEM", description: "Items only"
  end
end
