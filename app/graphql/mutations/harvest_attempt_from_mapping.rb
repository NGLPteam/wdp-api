# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestAttemptFromMapping
  class HarvestAttemptFromMapping < Mutations::AbstractHarvestAttemptMutation
    include Mutations::Shared::AcceptsHarvestExtractionMappingTemplate

    description <<~TEXT
    Kick off a manual `HarvestAttempt` from a `HarvestMapping`
    TEXT

    field :harvest_attempt, Types::HarvestAttemptType, null: true do
      description <<~TEXT
      The newly-modified harvest mapping, if successful.
      TEXT
    end

    argument :harvest_mapping_id, ID, loads: Types::HarvestMappingType, required: true do
      description <<~TEXT
      The harvest mapping to update.
      TEXT
    end

    argument :note, String, required: false do
      description <<~TEXT
      An optional note for this harvesting attempt.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_attempt_from_mapping"
  end
end
