# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestMappingCreate
  class HarvestMappingCreate < Mutations::MutateHarvestMapping
    description <<~TEXT
    Create a single `HarvestMapping` record.
    TEXT

    argument :harvest_source_id, ID, loads: Types::HarvestSourceType, required: true do
      description <<~TEXT
      The harvest source to create the mapping for.

      This cannot be changed since mappings are intricately tied to sources.
      TEXT
    end

    argument :harvest_set_id, ID, loads: Types::HarvestSetType, required: false do
      description <<~TEXT
      An optional set to associate with the mapping.

      This cannot be changed since mappings are intricately tied to their set (if applicable).
      TEXT
    end

    argument :metadata_format, Types::HarvestMetadataFormatType, required: true do
      description <<~TEXT
      The metadata format for this mapping to use, which can be different from the Harvest Source.

      It should default to whatever the harvest source uses.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_mapping_create"
  end
end
