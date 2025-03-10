# frozen_string_literal: true

module Harvesting
  module Frozen
    # @see Harvesting::Example
    # @see Harvesting::Frozen::Types
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :extraction_mapping, Harvesting::Frozen::Types::ExtractionMapping
      tc.add! :identifier, Harvesting::Frozen::Types::Identifier
      tc.add! :metadata_format, Harvesting::Types::MetadataFormat
      tc.add! :metadata_format_name, Harvesting::Types::MetadataFormatName
      tc.add! :protocol, Harvesting::Types::Protocol
      tc.add! :protocol_name, Harvesting::Types::ProtocolName
      tc.add! :schema_declaration, Harvesting::Frozen::Types::SchemaDeclaration
      tc.add! :schema_declarations, Harvesting::Frozen::Types::SchemaDeclarations
      tc.add! :schema_version, Harvesting::Frozen::Types::SchemaVersion
      tc.add! :schema_versions, Harvesting::Frozen::Types::SchemaVersions
    end
  end
end
