# frozen_string_literal: true

module Resolvers
  class ItemContributionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::OrderedAsContribution
    include Resolvers::PageBasedPagination

    type Types::ItemContributionType.connection_type, null: false

    scope do
      case object
      when Contributor
        object.item_contributions
      when Item
        object.contributions
      else
        # :nocov:
        ItemContribution.none
        # :nocov:
      end
    end
  end
end
