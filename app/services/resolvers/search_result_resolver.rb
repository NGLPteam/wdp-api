# frozen_string_literal: true

module Resolvers
  class SearchResultResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::EnhancedResolver
    include Resolvers::FiltersByEntityDescendantScope
    include Resolvers::FiltersBySchemaName
    include Resolvers::FinalizesResults
    include Resolvers::OrderedAsEntity
    include Resolvers::PageBasedPagination

    type ::Types::SearchResultType.connection_type, null: false

    description <<~TEXT
    The results of a search. Either `query` or `predicates` should be provided,
    otherwise it will return as if everything matches.
    TEXT

    scope { object.base_relation.all }

    PREDICATES_DESC = <<~TEXT
    The predicates to search for, if any.
    TEXT

    option :predicates, type: [Types::SearchPredicateInputType, { null: false }], default: [], description: PREDICATES_DESC do |scope, predicates|
      scope.apply_search_predicates predicates.flatten
    end

    PREFIX_DESC = <<~TEXT
    Search for entities with titles that start with the provided text (case-insensitive).
    TEXT

    option :prefix, type: String, description: PREFIX_DESC do |scope, value|
      scope.apply_prefix value
    end

    QUERY_DESC = <<~TEXT
    Search all text associated with individual entities.

    Basic quoting and similar features are supported. See
    [websearch_to_tsquery](https://www.postgresql.org/docs/13/textsearch-controls.html) for
    more information.
    TEXT

    option :query, type: String, description: QUERY_DESC do |scope, value|
      scope.apply_query value
    end

    def finalize(scope)
      # If no search options are provided, we return an empty set.
      return scope.none if predicates.blank? && query.blank? && prefix.blank?

      scope.apply_order_to_exclude_duplicate_links
    end

    def unfiltered_scope
      super.apply_order_to_exclude_duplicate_links
    end
  end
end
