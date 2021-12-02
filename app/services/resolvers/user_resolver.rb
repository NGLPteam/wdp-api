# frozen_string_literal: true

module Resolvers
  class UserResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::AppliesPolicyScope
    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsUser

    type Types::UserType.connection_type, null: false

    option :order, type: Types::UserOrderType, default: "RECENT"

    scope { User.all }
  end
end
