# frozen_string_literal: true

module Resolvers
  class UserResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::AppliesPolicyScope
    include Resolvers::PageBasedPagination
    include Resolvers::OrderedAsUser

    type Types::UserType.connection_type, null: false

    option :order, type: Types::UserOrderType, default: "RECENT"

    PREFIX_DESC = <<~TEXT
    Search for users with given OR family names that start with the provided text.
    TEXT

    option :prefix, type: String, description: PREFIX_DESC do |scope, value|
      scope.apply_prefix value
    end

    scope { User.all }
  end
end
