# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestSourceUpdate
  class HarvestSourceUpdate < Mutations::MutateHarvestSource
    description <<~TEXT
    Update a single `HarvestSource` record.
    TEXT

    argument :harvest_source_id, ID, loads: Types::HarvestSourceType, required: true do
      description <<~TEXT
      The harvest source to update.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_source_update"
  end
end
