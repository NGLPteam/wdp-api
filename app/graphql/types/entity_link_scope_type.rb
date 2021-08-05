# frozen_string_literal: true

module Types
  class EntityLinkScopeType < Types::BaseEnum
    description "A link scope succinctly describes the source and target types"

    value "COMMUNITY_LINKED_COMMUNITY", value: "communities.linked.communities", description: "A link to a community from another community"
    value "COMMUNITY_LINKED_COLLECTION", value: "communities.linked.collections", description: "A link to a collection not directly owned by a community"
    value "COMMUNITY_LINKED_ITEM", value: "communities.linked.items", description: "A link to an item from a community"
    value "COLLECTION_LINKED_COMMUNITY", value: "collections.linked.communities", description: "A link to a community from a collection"
    value "COLLECTION_LINKED_COLLECTION", value: "collections.linked.collections", description: "A link to a collection from another collection"
    value "COLLECTION_LINKED_ITEM", value: "collections.linked.items", description: "A link to an item from a community"
    value "ITEM_LINKED_COMMUNITY", value: "items.linked.communities", description: "A link to a community from an item"
    value "ITEM_LINKED_COLLECTION", value: "items.linked.collections", description: "A link to a collection from an item"
    value "ITEM_LINKED_ITEM", value: "items.linked.items", description: "A link to an item from another item"
  end
end
