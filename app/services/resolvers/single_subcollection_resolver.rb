# frozen_string_literal: true

module Resolvers
  # A resolver for getting the first-matching {Collection} below a {Collection}.
  class SingleSubcollectionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::FirstMatching
    include Resolvers::OrderedAsEntity
    include Resolvers::Subtreelike

    description "Retrieve the first matching collection beneath this collection."

    type "Types::CollectionType", null: true

    graphql_name "Collection"

    scope do
      case object
      when Collection
        object.descendants.reorder(nil)
      when Community
        object.collections.reorder(nil)
      else
        # :nocov:
        Collection.none
        # :nocov:
      end
    end
  end
end
