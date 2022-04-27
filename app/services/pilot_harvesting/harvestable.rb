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

      attribute? :set_identifier, PilotHarvesting::Types::String.optional

      attribute? :max_records, PilotHarvesting::Types::Integer.constrained(gt: 0, lteq: 5000).default(5000)

      attribute? :metadata_format, Harvesting::Types::MetadataFormat.optional

      attribute? :protocol_name, Harvesting::Types::ProtocolName.optional

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
          call_operation("harvesting.actions.upsert_set_mapping", source, entity, set_identifier, **options) do |mapping|
            call_operation("harvesting.actions.manually_run_mapping", mapping) do
              Success entity
            end
          end
        else
          call_operation("harvesting.actions.manually_run_source", source, entity) do
            Success entity
          end
        end
      end
    end
  end
end