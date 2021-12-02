# frozen_string_literal: true

module Resolvers
  class UserGroupUserResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::AppliesPolicyScope
    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsUser

    type Types::UserType.connection_type, null: false

    scope { object.users }
  end
end
