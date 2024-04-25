# frozen_string_literal: true

module Resolvers
  # @see RelatedCollectionLink
  class RelatedCollectionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsEntity

    description "Retrieve linked collections of the same schema type"

    type "Types::CollectionConnectionType", null: false

    graphql_name "CollectionConnection"

    scope do
      object.related_collections
    end
  end
end
