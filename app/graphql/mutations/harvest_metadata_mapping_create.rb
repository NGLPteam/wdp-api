# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestMetadataMappingCreate
  class HarvestMetadataMappingCreate < Mutations::MutateHarvestMetadataMapping
    description <<~TEXT
    Create a single `HarvestMetadataMapping` record.

    There is no `harvestMetadataMappingUpdate` mutation. You can replace an existing field/pattern pair with a new target entity,
    or destroy ones that no longer apply.
    TEXT

    performs_operation! "mutations.operations.harvest_metadata_mapping_create"

    argument :harvest_source_id, ID, loads: Types::HarvestSourceType, required: true do
      description <<~TEXT
      The source to create the harvest metadata mapping for.
      TEXT
    end
  end
end
