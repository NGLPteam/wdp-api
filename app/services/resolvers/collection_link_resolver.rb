# frozen_string_literal: true

module Resolvers
  class CollectionLinkResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::CollectionLinkType.connection_type, null: false

    scope { object.collection_links }
  end
end
