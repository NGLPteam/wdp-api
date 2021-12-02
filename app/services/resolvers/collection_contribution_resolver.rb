# frozen_string_literal: true

module Resolvers
  class CollectionContributionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::OrderedAsContribution
    include Resolvers::PageBasedPagination

    type Types::CollectionContributionType.connection_type, null: false

    scope do
      case object
      when Contributor
        object.collection_contributions
      when Collection
        object.contributions
      else
        # :nocov:
        CollectionContribution.none
        # :nocov:
      end
    end
  end
end
