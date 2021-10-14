# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class CommunityResolver < GraphQL::Schema::Resolver
      include SearchObject.module(:graphql)

      include Resolvers::FiltersByAccessGrantSubject
      include Resolvers::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::AnyCommunityAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_communities
        else
          AccessGrant.none
        end
      end
    end
  end
end
