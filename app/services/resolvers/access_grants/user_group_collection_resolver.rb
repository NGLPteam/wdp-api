# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class UserGroupCollectionResolver < GraphQL::Schema::Resolver
      include SearchObject.module(:graphql)

      include Resolvers::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::UserGroupCollectionAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_collections.for_groups
        else
          AccessGrant.none
        end
      end
    end
  end
end
