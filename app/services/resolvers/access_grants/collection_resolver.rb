# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class CollectionResolver < AbstractResolver
      include Resolvers::FiltersByAccessGrantSubject
      include Resolvers::Enhancements::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::AnyCollectionAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_collections
        else
          AccessGrant.none
        end
      end
    end
  end
end
