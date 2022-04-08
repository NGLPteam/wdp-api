# frozen_string_literal: true

module Resolvers
  class SearchResultResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::OrderedAsEntity
    include Resolvers::PageBasedPagination

    type Types::SearchResultType.connection_type, null: false

    scope { object.base_relation.all }

    option :predicates, type: [Types::SearchPredicateInputType, { null: false }], default: [] do |scope, predicates|
      scope.apply_search_predicates predicates.flatten
    end

    option :query, type: String do |scope, value|
      scope.apply_query value
    end
  end
end
