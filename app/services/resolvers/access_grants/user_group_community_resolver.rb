# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class UserGroupCommunityResolver < AbstractResolver
      include Resolvers::Enhancements::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::UserGroupCommunityAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_communities.for_groups
        else
          AccessGrant.none
        end
      end
    end
  end
end
