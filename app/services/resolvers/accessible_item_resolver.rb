# frozen_string_literal: true

module Resolvers
  class AccessibleItemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::FiltersByEntityPermission
    include Resolvers::SimplyOrdered
    include Resolvers::Treelike

    type Types::ItemType.connection_type, null: false

    scope { Item.all }
  end
end
