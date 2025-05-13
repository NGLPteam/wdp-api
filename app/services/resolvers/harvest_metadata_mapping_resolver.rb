# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestMetadataMapping}.
  #
  # @see HarvestMetadataMapping
  # @see Types::HarvestMetadataMappingType
  class HarvestMetadataMappingResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsHarvestMetadataMapping

    type Types::HarvestMetadataMappingType.connection_type, null: false

    scope do
      if object.present?
        object.try(:harvest_metadata_mappings) || ::HarvestMetadataMapping.none
      else
        ::HarvestMetadataMapping.all
      end
    end

    # filters_with! Filtering::Scopes::HarvestMetadataMappings
  end
end
