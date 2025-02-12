# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestSet}.
  #
  # @see HarvestSet
  # @see Types::HarvestSetType
  class HarvestSetResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsHarvestSet

    type Types::HarvestSetType.connection_type, null: false

    scope do
      if object.present?
        object.try(:harvest_sets) || HarvestSet.none
      else
        HarvestSet.all
      end
    end

    filters_with! Filtering::Scopes::HarvestSets
  end
end
