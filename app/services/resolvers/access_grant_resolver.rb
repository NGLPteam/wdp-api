# frozen_string_literal: true

module Resolvers
  class AccessGrantResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::FiltersByAccessGrantEntity
    include Resolvers::FiltersByAccessGrantSubject
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::SimplyOrdered

    type Types::AnyAccessGrantType.connection_type, null: false

    scope do
      if object.respond_to?(:access_grants)
        object.access_grants.with_preloads
      else
        AccessGrant.all
      end
    end
  end
end
