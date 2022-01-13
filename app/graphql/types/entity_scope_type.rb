# frozen_string_literal: true

module Types
  # This attribute is used for authorization and other features,
  # and can distinguish an entity that has been linked from one
  # that exists directly in the hierarchy.
  class EntityScopeType < Types::BaseEnum
    description <<~TEXT
    This type is used for authorization and filtering, and can
    distinguish an entity that has been linked to another from
    one that exists directly in a hierarchy.
    TEXT

    value "COMMUNITY", value: "communities" do
      description <<~TEXT
      A `Community` that is an actual descendant at this point in the hierarchy.
      TEXT
    end

    value "COLLECTION", value: "collections" do
      description <<~TEXT
      A `Collection` that is an actual descendant at this point in the hierarchy.
      TEXT
    end

    value "ITEM", value: "items" do
      description <<~TEXT
      An `Item` that is an actual descendant at this point in the hierarchy.
      TEXT
    end

    value "COMMUNITY_LINKED_COMMUNITY", value: "communities.linked.communities" do
      description <<~TEXT
      A `Community` that was linked from another `Community`.
      TEXT
    end

    value "COMMUNITY_LINKED_COLLECTION", value: "communities.linked.collections" do
      description <<~TEXT
      A `Collection` that was linked from a `Community`.
      TEXT
    end

    value "COMMUNITY_LINKED_ITEM", value: "communities.linked.items" do
      description <<~TEXT
      An `Item` that was linked from a `Community`.
      TEXT
    end

    value "COLLECTION_LINKED_COMMUNITY", value: "collections.linked.communities" do
      description <<~TEXT
      A `Community` that was linked from a `Collection`.
      TEXT
    end

    value "COLLECTION_LINKED_COLLECTION", value: "collections.linked.collections" do
      description <<~TEXT
      A `Collection` that was linked from another `Collection`.
      TEXT
    end

    value "COLLECTION_LINKED_ITEM", value: "collections.linked.items" do
      description <<~TEXT
      An `Item` that was linked from a `Collection`.
      TEXT
    end

    value "ITEM_LINKED_COMMUNITY", value: "items.linked.communities" do
      description <<~TEXT
      A `Community` that was linked from an `Item`.
      TEXT
    end

    value "ITEM_LINKED_COLLECTION", value: "items.linked.collections" do
      description <<~TEXT
      A `Collection` that was linked from an `Item`.
      TEXT
    end

    value "ITEM_LINKED_ITEM", value: "items.linked.items" do
      description <<~TEXT
      An `Item` that was linked from another `Item`.
      TEXT
    end
  end
end
