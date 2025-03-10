# frozen_string_literal: true

module Types
  class HarvestExampleType < BaseObject
    description <<~TEXT
    An example of various harvesting configurations, particularly extraction mapping templates.
    TEXT

    field :id, ID, null: false do
      description <<~TEXT
      The ID for the example.
      TEXT
    end

    field :name, String, null: false do
      description <<~TEXT
      The human-readable name for the example.
      TEXT
    end

    field :description, String, null: true do
      description <<~TEXT
      A description about the example, if available.
      TEXT
    end

    field :protocol_name, Types::HarvestProtocolType, null: true do
      description <<~TEXT
      The protocol this example applies to.

      It can be blank if the example is not protocol-specific.
      TEXT
    end

    field :metadata_format_name, Types::HarvestMetadataFormatType, null: true do
      description <<~TEXT
      The metadata format this example applies to.

      It can be blank if the example is not metadata-specific.
      TEXT
    end

    field :default, Boolean, null: false do
      description <<~TEXT
      Whether this should be considered a "default" example
      for a given metadata / protocol combination.
      TEXT
    end

    field :generic, Boolean, null: false do
      description <<~TEXT
      Whether this is a generic example that is not tied
      to any specific protocol nor metadata format.
      TEXT
    end

    field :extraction_mapping_template, String, null: false do
      description <<~TEXT
      The example's extraction mapping template which can be applied to harvest sources, mappings, and attempts.
      TEXT
    end

    field :schema_declarations, [String, { null: false }], null: false do
      description <<~TEXT
      A list of schema declarations that the mapping template can generate.
      TEXT
    end

    field :schema_versions, [Types::SchemaVersionType, { null: false }], null: false do
      description <<~TEXT
      A list of schema versions that the mapping template can generate.
      TEXT
    end
  end
end
