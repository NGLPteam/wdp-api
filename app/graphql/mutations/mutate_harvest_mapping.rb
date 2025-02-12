# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::CreateHarvestMapping
  # @see Mutations::UpdateHarvestMapping
  class MutateHarvestMapping < Mutations::BaseMutation
    include Mutations::Shared::AcceptsHarvestOptions

    description <<~TEXT
    A base mutation that is used to share fields between `createHarvestMapping` and `updateHarvestMapping`.
    TEXT

    field :harvest_mapping, Types::HarvestMappingType, null: true do
      description <<~TEXT
      The newly-modified harvest mapping, if successful.
      TEXT
    end

    argument :target_entity_id, ID, loads: Types::HarvestTargetType, required: true do
      description <<~TEXT
      The community or collection to target for this mapping.

      This can be changed if the mapping needs to be retargeted in the hierarchy.
      TEXT
    end
  end
end
