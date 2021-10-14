# frozen_string_literal: true

module Resolvers
  class AccessGrantResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::AppliesPolicyScope
    include Resolvers::FiltersByAccessGrantEntity
    include Resolvers::FiltersByAccessGrantSubject
    include Resolvers::PageBasedPagination
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
