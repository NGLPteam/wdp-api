# frozen_string_literal: true

module Resolvers
  class SubcollectionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type "Types::CollectionConnectionType", null: false

    graphql_name "CollectionConnection"

    scope do
      if object.present? && object.kind_of?(Collection)
        object.children
      elsif object.present? && object.respond_to?(:collections)
        object.collections
      else
        # :nocov:
        Collection.none
        # :nocov:
      end
    end
  end
end
