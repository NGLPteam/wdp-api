# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestMessage}.
  #
  # @see HarvestMessage
  # @see Types::HarvestMessageType
  class HarvestMessageResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination

    type Types::HarvestMessageType.connection_type, null: false

    scope do
      if object.present?
        object.try(:harvest_messages).try(:in_default_order) || HarvestMessage.none
      else
        HarvestMessage.in_default_order
      end
    end

    filters_with! Filtering::Scopes::HarvestMessages
  end
end
