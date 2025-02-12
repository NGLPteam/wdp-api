# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestMappingDestroy
  class HarvestMappingDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `HarvestMapping` record.
    TEXT

    argument :harvest_mapping_id, ID, loads: Types::HarvestMappingType, required: true do
      description <<~TEXT
      The harvest mapping to destroy.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_mapping_destroy", destroy: true
  end
end
