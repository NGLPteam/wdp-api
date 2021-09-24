# frozen_string_literal: true

module Resolvers
  class AssignedUserResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::UserType.connection_type, null: false

    scope { object.assigned_users }
  end
end
