# frozen_string_literal: true

module PilotHarvesting
  module Harvestable
    extend ActiveSupport::Concern

    included do
      defines :metadata_format, type: Harvesting::Types::MetadataFormat

      metadata_format "mods"

      defines :protocol_name, type: Harvesting::Types::ProtocolName

      protocol_name "oai"

      defines :harvesting_identifier, type: PilotHarvesting::Types::Symbol

      harvesting_identifier :identifier

      defines :harvesting_title, type: PilotHarvesting::Types::Symbol

      harvesting_title :title

      attribute? :url, PilotHarvesting::Types::SourceURL

      attribute? :add_set, PilotHarvesting::Types::Bool.default(false)

      attribute? :set_identifier, PilotHarvesting::Types::String.optional

      attribute? :link_identifiers_globally, PilotHarvesting::Types::Bool.default(false)

      attribute? :max_records, Harvesting::Types::MaxRecordCount

      attribute? :metadata_format, Harvesting::Types::MetadataFormat.optional

      attribute? :protocol_name, Harvesting::Types::ProtocolName.optional

      attribute? :skip_harvest, Harvesting::Types::Bool.default(false)

      delegate :metadata_format, :protocol_name, to: :class, prefix: :default
    end

    # @!attribute [r] harvesting_identifier
    # @return [String]
    def harvesting_identifier
      public_send self.class.harvesting_identifier
    end

    # @!attribute [r] harvesting_title
    # @return [String]
    def harvesting_title
      public_send self.class.harvesting_title
    end

    # @!attribute [r] harvesting_metadata_format
    # @return [Harvesting::Types::MetadataFormat]
    def harvesting_metadata_format
      metadata_format.presence || default_metadata_format
    end

    # @!attribute [r] protocol_name
    # @return [Harvesting::Types::ProtocolName]
    def harvesting_protocol_name
      protocol_name || default_protocol_name
    end

    # @param [HierarchicalEntity] entity
    # @return [Dry::Monads::Result]
    def upsert_source_for!(entity)
      return Success(entity) if url.blank?

      options = {
        mapping_options: {
          link_identifiers_globally: link_identifiers_globally,
        },
        read_options: {
          max_records: max_records,
        },
      }

      source_options = options.merge(
        metadata_format: harvesting_metadata_format,
        protocol_name: harvesting_protocol_name,
      )

      call_operation("harvesting.sources.upsert", harvesting_identifier, harvesting_title, url, **source_options) do |source|
        if set_identifier.present?
          call_operation("harvesting.actions.upsert_set_mapping", source, entity, set_identifier, add_set_if_missing: add_set, **options) do |mapping|
            call_operation("harvesting.actions.manually_run_mapping", mapping, skip_harvest: skip_harvest) do
              Success entity
            end
          end
        else
          call_operation("harvesting.actions.manually_run_source", source, entity, skip_harvest: skip_harvest) do
            Success entity
          end
        end
      end
    end
  end
end
