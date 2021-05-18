# frozen_string_literal: true

module Resolvers
  class ItemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::SimplyOrdered
    include Resolvers::Treelike

    type Types::ItemType.connection_type, null: false

    scope { object.items }
  end
end
