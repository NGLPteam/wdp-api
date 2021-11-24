# frozen_string_literal: true

module Resolvers
  class AccessibleCommunityResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::FiltersByEntityPermission
    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsEntity
    include Resolvers::Treelike

    type Types::CommunityType.connection_type, null: false

    scope { Community.all }
  end
end
