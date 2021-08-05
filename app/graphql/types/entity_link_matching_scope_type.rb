# frozen_string_literal: true

module Types
  class EntityLinkMatchingScopeType < Types::BaseEnum
    description "These queries are used to drill down the types of links we are looking for"

    value "TO_COMMUNITY", value: "*{1}.linked.communities"
    value "TO_COLLECTION", value: "*{1}.linked.collections"
    value "TO_ITEM", value: "*{1}.linked.items"
  end
end
