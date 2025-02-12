# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestAttempt}.
  #
  # @see HarvestAttempt
  # @see Types::HarvestAttemptType
  class HarvestAttemptResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsHarvestAttempt

    type Types::HarvestAttemptType.connection_type, null: false

    scope do
      if object.present?
        object.try(:harvest_attempts) || HarvestAttempt.none
      else
        HarvestAttempt.all
      end
    end
  end
end
