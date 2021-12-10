# frozen_string_literal: true

module Resolvers
  # A resolver for getting {Item}s below an {Item}.
  class SubitemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsEntity
    include Resolvers::Subtreelike

    description "Retrieve the items beneath this item"

    type "Types::ItemConnectionType", null: false

    graphql_name "ItemConnection"

    scope do
      if object.kind_of?(Item)
        object.descendants.reorder(nil)
      else
        # :nocov:
        Item.none
        # :nocov:
      end
    end
  end
end
