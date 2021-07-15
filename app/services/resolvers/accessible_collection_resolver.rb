# frozen_string_literal: true

module Resolvers
  class AccessibleCollectionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::FiltersByEntityPermission
    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered
    include Resolvers::Treelike

    type Types::CollectionConnectionType, null: false

    scope { Collection.all }
  end
end
