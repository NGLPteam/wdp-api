# frozen_string_literal: true

module Resolvers
  class UserResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::AppliesPolicyScope
    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::UserType.connection_type, null: false

    scope { User.all }
  end
end
