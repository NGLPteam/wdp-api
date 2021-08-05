# frozen_string_literal: true

module Resolvers
  class OrderingEntryResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::PositionOrdered

    type Types::OrderingEntryType.connection_type, null: false

    scope { object.ordering_entries }
  end
end
