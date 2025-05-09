# frozen_string_literal: true

module Resolvers
  # A resolver for getting {Collection}s below a {Collection}.
  class SubcollectionResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::FiltersByEntityPermission
    include Resolvers::OrderedAsEntity
    include Resolvers::Subtreelike

    description "Retrieve the collections beneath this collection."

    type "Types::CollectionConnectionType", null: false

    graphql_name "CollectionConnection"

    scope do
      object.descendants.reorder(nil)
    end
  end
end
