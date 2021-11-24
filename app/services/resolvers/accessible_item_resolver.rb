# frozen_string_literal: true

module Resolvers
  class AccessibleItemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::FiltersByEntityPermission
    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsEntity
    include Resolvers::Treelike

    type Types::ItemConnectionType, null: false

    scope { Item.all }
  end
end
