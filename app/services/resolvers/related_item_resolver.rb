# frozen_string_literal: true

module Resolvers
  # @see RelatedItemLink
  class RelatedItemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsEntity

    description "Retrieve linked items of the same schema type"

    type "Types::ItemConnectionType", null: false

    graphql_name "ItemConnection"

    scope do
      object.related_items
    end
  end
end
