# frozen_string_literal: true

module Resolvers
  class OrderingResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsOrdering

    type Types::OrderingType.connection_type, null: false

    scope { object.orderings }
  end
end
