# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestMappingUpdate
  class HarvestMappingUpdate < Mutations::MutateHarvestMapping
    description <<~TEXT
    Update a single `HarvestMapping` record.
    TEXT

    argument :harvest_mapping_id, ID, loads: Types::HarvestMappingType, required: true do
      description <<~TEXT
      The harvest mapping to update.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_mapping_update"
  end
end
