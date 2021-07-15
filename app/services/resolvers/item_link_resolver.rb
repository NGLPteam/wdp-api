# frozen_string_literal: true

module Resolvers
  class ItemLinkResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::ItemLinkType.connection_type, null: false

    scope { object.item_links }
  end
end
