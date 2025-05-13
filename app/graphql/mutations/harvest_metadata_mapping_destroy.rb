# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestMetadataMappingDestroy
  class HarvestMetadataMappingDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `HarvestMetadataMapping` record.
    TEXT

    argument :harvest_metadata_mapping_id, ID, loads: Types::HarvestMetadataMappingType, required: true do
      description <<~TEXT
      The harvest metadata mapping to destroy.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_metadata_mapping_destroy", destroy: true
  end
end
