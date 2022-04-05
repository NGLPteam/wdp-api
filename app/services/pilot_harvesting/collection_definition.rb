# frozen_string_literal: true

module PilotHarvesting
  # @abstract
  class CollectionDefinition < Struct
    include Dry::Effects.Resolve(:community)

    defines :metadata_format, type: Harvesting::Types::MetadataFormat

    metadata_format "mods"

    defines :protocol_name, type: Harvesting::Types::ProtocolName

    protocol_name "oai"

    attribute :identifier, Types::String

    attribute :title, Types::String

    attribute? :url, Types::SourceURL

    delegate :metadata_format, :protocol_name, to: :class

    def upsert
      call_operation("collections.upsert", identifier, title: title, parent: collection_parent, properties: properties) do |collection|
        upsert_source_for!(collection).value!

        Success collection
      end
    end

    def collection_parent
      community
    end

    def properties
      {}
    end

    private

    def upsert_source_for!(collection)
      return Success() if url.blank?

      call_operation("harvesting.sources.upsert", title, url, metadata_format: metadata_format, protocol: protocol_name) do |source|
        call_operation("harvesting.actions.manually_run_source", source, collection).value!

        Success collection
      end
    end
  end
end
