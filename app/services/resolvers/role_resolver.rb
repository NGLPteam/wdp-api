# frozen_string_literal: true

module Resolvers
  class RoleResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::SimplyOrdered

    type Types::RoleType.connection_type, null: false

    scope { Role.all }
  end
end
