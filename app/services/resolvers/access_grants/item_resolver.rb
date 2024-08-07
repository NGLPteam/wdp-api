# frozen_string_literal: true

module Resolvers
  module AccessGrants
    class ItemResolver < AbstractResolver
      include Resolvers::FiltersByAccessGrantSubject
      include Resolvers::Enhancements::PageBasedPagination
      include Resolvers::SimplyOrdered

      type Types::AnyItemAccessGrantType.connection_type, null: false

      scope do
        if object.respond_to?(:access_grants)
          object.access_grants.with_preloads.for_items
        else
          AccessGrant.none
        end
      end
    end
  end
end
