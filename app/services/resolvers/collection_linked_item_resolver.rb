# frozen_string_literal: true

module Resolvers
  class CollectionLinkedItemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::CollectionLinkedItemType.connection_type, null: false

    scope { object.collection_linked_items }
  end
end
