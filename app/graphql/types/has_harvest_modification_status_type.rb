# frozen_string_literal: true

module Types
  # @see ::HasHarvestModificationStatus
  # @see Types::HarvestModificationStatusType
  module HasHarvestModificationStatusType
    include Types::BaseInterface

    description <<~TEXT
    An interface for records which can be created/updated through Harvesting
    that includes an enum which can prevent harvesting actions from overwriting
    any data that has been manually corrected.
    TEXT

    field :harvest_modification_status, Types::HarvestModificationStatusType, null: false do
      description <<~TEXT
      The status of the harvesting modification. If it is `MODIFIED`, harvesting actions will have
      no effect on this record.
      TEXT
    end
  end
end
