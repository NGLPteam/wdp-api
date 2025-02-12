# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestSource}.
  #
  # @see HarvestSource
  # @see Types::HarvestSourceType
  class HarvestSourceResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsHarvestSource

    type Types::HarvestSourceType.connection_type, null: false

    scope { ::HarvestSource.all }
  end
end
