# frozen_string_literal: true

module Resolvers
  class CollectionContributionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::CollectionContributionType.connection_type, null: false

    scope { object.contributions }
  end
end
