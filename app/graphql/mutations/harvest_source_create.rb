# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestSourceCreate
  class HarvestSourceCreate < Mutations::MutateHarvestSource
    description <<~TEXT
    Create a single `HarvestSource` record.
    TEXT

    argument :identifier, String, required: true do
      description <<~TEXT
      A unique, machine-readable identifier. Requirements:

      * At least three characters: alphanumeric, hyphens, underscores
      * All lowercase
      * No whitespace
      * No consecutive hyphens nor underscores.

      Cannot be changed once created. To reuse an identifier, the original source
      must be destroyed.
      TEXT
    end

    argument :protocol, Types::HarvestProtocolType, required: true, default_value: "oai" do
      description <<~TEXT
      The protocol for this source.

      Cannot be changed once created.
      TEXT
    end

    argument :metadata_format, Types::HarvestMetadataFormatType, required: true do
      description <<~TEXT
      The metadata format for this source to use by default.

      Mappings can override this, but it cannot be changed currently.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_source_create"
  end
end
