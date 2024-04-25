# frozen_string_literal: true

module Resolvers
  module AccessGrants
    # A resolver for {Types::AccessGrantSubjectType}.
    class SubjectResolver < AbstractResolver
      include Resolvers::FiltersByAccessGrantEntity
      include Resolvers::Enhancements::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::AnyAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads
        else
          AccessGrant.none
        end
      end
    end
  end
end
