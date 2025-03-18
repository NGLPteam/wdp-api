# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestAttemptFromSource
  class HarvestAttemptFromSource < Mutations::AbstractHarvestAttemptMutation
    include Mutations::Shared::AcceptsHarvestExtractionMappingTemplate

    description <<~TEXT
    Kick off a manual `HarvestAttempt` from a `HarvestSource`
    TEXT

    field :harvest_source, Types::HarvestSourceType, null: true do
      description <<~TEXT
      The newly-modified harvest source, if successful.
      TEXT
    end

    argument :harvest_source_id, ID, loads: Types::HarvestSourceType, required: true do
      description <<~TEXT
      The harvest source to use as the base.
      TEXT
    end

    argument :target_entity_id, ID, loads: Types::HarvestTargetType, required: true do
      description <<~TEXT
      The community or collection to target for the harvest.
      TEXT
    end

    argument :harvest_set_id, ID, loads: Types::HarvestSetType, required: false do
      description <<~TEXT
      An optional set to restrict the attempt to.
      TEXT
    end

    argument :note, String, required: false do
      description <<~TEXT
      An optional note for this harvesting attempt.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_attempt_from_source"
  end
end
