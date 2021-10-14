# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class UserGroupResolver < GraphQL::Schema::Resolver
      include SearchObject.module(:graphql)

      include Resolvers::FiltersByAccessGrantEntity
      include Resolvers::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::AnyUserGroupAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_groups
        else
          AccessGrant.none
        end
      end
    end
  end
end
