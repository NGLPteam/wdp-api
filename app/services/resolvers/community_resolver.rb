# frozen_string_literal: true

module Resolvers
  class CommunityResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsEntity

    type Types::CommunityType.connection_type, null: false

    scope { Community.all }
  end
end
