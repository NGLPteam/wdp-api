# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestMapping}.
  #
  # @see HarvestMapping
  # @see Types::HarvestMappingType
  class HarvestMappingResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsHarvestMapping

    type Types::HarvestMappingType.connection_type, null: false

    scope do
      if object.present?
        object.try(:harvest_mappings) || ::HarvestMapping.none
      else
        ::HarvestMapping.all
      end
    end

    # filters_with! Filtering::Scopes::HarvestMappings
  end
end
