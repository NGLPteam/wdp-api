# frozen_string_literal: true

module Resolvers
  # A resolver for a {HarvestRecord}.
  #
  # @see HarvestRecord
  # @see Types::HarvestRecordType
  class HarvestRecordResolver < AbstractResolver
    include Resolvers::Enhancements::AppliesPolicyScope
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsHarvestRecord

    type Types::HarvestRecordType.connection_type, null: false

    scope do
      if object.present?
        object.try(:harvest_records) || HarvestRecord.none
      else
        HarvestRecord.all
      end
    end
  end
end
