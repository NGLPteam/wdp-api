# frozen_string_literal: true

module Resolvers
  # Orders {Role} models.
  class RoleResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::OrderedAsRole

    type Types::RoleType.connection_type, null: false

    scope { Role.all }
  end
end
