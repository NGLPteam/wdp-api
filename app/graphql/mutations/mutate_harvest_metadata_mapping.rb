# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::CreateHarvestMetadataMapping
  # @see Mutations::UpdateHarvestMetadataMapping
  class MutateHarvestMetadataMapping < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `createHarvestMetadataMapping` and `updateHarvestMetadataMapping`.
    TEXT

    field :harvest_metadata_mapping, Types::HarvestMetadataMappingType, null: true do
      description <<~TEXT
      The newly-modified harvest metadata mapping, if successful.
      TEXT
    end

    argument :field, ::Types::HarvestMetadataMappingFieldType, required: true do
      description <<~TEXT
      Which "field" this should try to match its `pattern` against.
      TEXT
    end

    argument :pattern, String, required: true do
      description <<~TEXT
      A regular expression / pattern to match against. Must be written to support postgres regular expressions,
      which are more limited than most modern languages but follow the ANSI spec as much as possible.
      TEXT
    end

    argument :target_entity_id, ID, loads: Types::HarvestTargetType, required: true do
      description <<~TEXT
      The entity that will act as the parent when this metadata mapping is matched.
      TEXT
    end
  end
end
