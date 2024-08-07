# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class UserCollectionResolver < AbstractResolver
      include Resolvers::Enhancements::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::UserCollectionAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_collections.for_users
        else
          AccessGrant.none
        end
      end
    end
  end
end
