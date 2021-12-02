# frozen_string_literal: true

module Resolvers
  # A resolver for getting {Item}s below an {Item}.
  class SubcollectionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsEntity
    include Resolvers::Subtreelike

    description "Retrieve the collections beneath this collection."

    type "Types::CollectionConnectionType", null: false

    graphql_name "CollectionConnection"

    scope do
      if object.kind_of?(Collection)
        object.descendants
      else
        # :nocov:
        Collection.none
        # :nocov:
      end
    end
  end
end
