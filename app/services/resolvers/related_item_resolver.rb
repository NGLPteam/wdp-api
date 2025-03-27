# frozen_string_literal: true

module Resolvers
  # @see RelatedItemLink
  class RelatedItemResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::FiltersByEntityPermission
    include Resolvers::OrderedAsEntity

    description "Retrieve linked items of the same schema type"

    type "Types::ItemConnectionType", null: false

    graphql_name "ItemConnection"

    scope do
      object.related_items
    end
  end
end
