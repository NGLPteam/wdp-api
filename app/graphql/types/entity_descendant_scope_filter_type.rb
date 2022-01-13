# frozen_string_literal: true

module Types
  # An enum used to distinguish what type of {EntityDescendant} to include.
  #
  # @see Resolvers::FiltersByEntityDescendantScope
  class EntityDescendantScopeFilterType < Types::BaseEnum
    description <<~TEXT
    This enum is used to filter the type(s) of descendants to include
    in a set of results.
    TEXT

    value "ALL" do
      description <<~TEXT
      This will include anything regardless of type.
      TEXT
    end

    value "ANY_ENTITY" do
      description <<~TEXT
      This will include all `Collection`s and `Item`s that are direct descendants and not linked.
      TEXT
    end

    value "ANY_LINK" do
      description <<~TEXT
      This will include any _linked_ `Collection`s or `Item`s.
      TEXT
    end

    value "COLLECTION" do
      description <<~TEXT
      This will include only directly descending `Collection`s, no links.
      TEXT
    end

    value "COLLECTION_OR_LINK" do
      description <<~TEXT
      This will include any descendant `Collection`s, whether or not it is a link.
      TEXT
    end

    value "ITEM" do
      description <<~TEXT
      This will include only directly descending `Item`s, no links.
      TEXT
    end

    value "ITEM_OR_LINK" do
      description <<~TEXT
      This will include any descendant `Item`s, whether or not it is a link.
      TEXT
    end

    value "LINKED_COLLECTION" do
      description <<~TEXT
      This will only descendant `Collection`s that are linked.
      TEXT
    end

    value "LINKED_ITEM" do
      description <<~TEXT
      This will only descendant `Item`s that are linked.
      TEXT
    end
  end
end
