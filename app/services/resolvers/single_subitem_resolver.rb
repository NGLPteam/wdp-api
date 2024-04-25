# frozen_string_literal: true

module Resolvers
  # A resolver for getting the first-matching {Item} below a {Item}.
  class SingleSubitemResolver < AbstractResolver
    include Resolvers::Enhancements::FirstMatching
    include Resolvers::OrderedAsEntity
    include Resolvers::Subtreelike

    description "Retrieve the first matching item beneath this item."

    type "Types::ItemType", null: true

    graphql_name "Item"

    scope do
      case object
      when Collection
        object.items.reorder(nil)
      when Community
        object.items.reorder(nil)
      when Item
        object.descendants.reorder(nil)
      else
        # :nocov:
        Item.none
        # :nocov:
      end
    end
  end
end
