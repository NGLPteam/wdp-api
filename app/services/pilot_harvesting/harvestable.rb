# frozen_string_literal: true

module PilotHarvesting
  module Harvestable
    extend ActiveSupport::Concern

    MetadataMapping = Types::Hash.schema(
      identifier: Types::Coercible::String,
      field: Types::Coercible::String,
      pattern: Types::Coercible::String,
    ).with_key_transform(&:to_sym)

    included do
      defines :metadata_format, type: Harvesting::Types::MetadataFormatName

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

      attribute? :auto_create_volumes_and_issues, PilotHarvesting::Types::Bool.default(false)

      attribute? :link_identifiers_globally, PilotHarvesting::Types::Bool.default(false)

      attribute? :use_metadata_mappings, PilotHarvesting::Types::Bool.default(false)

      attribute? :max_records, Harvesting::Types::MaxRecordCount

      attribute? :metadata_format, Harvesting::Types::MetadataFormatName.optional

      attribute? :protocol_name, Harvesting::Types::ProtocolName.optional

      attribute? :skip_harvest, Harvesting::Types::Bool.default(false)

      attribute? :metadata_mappings, Harvesting::Types::Array.of(MetadataMapping).default([].freeze)

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
    # @return [Harvesting::Types::MetadataFormatName]
    def harvesting_metadata_format
      metadata_format.presence || default_metadata_format
    end

    # @!attribute [r] protocol_name
    # @return [Harvesting::Types::ProtocolName]
    def harvesting_protocol_name
      protocol_name || default_protocol_name
    end

    def mapping_options
      {
        auto_create_volumes_and_issues:,
        link_identifiers_globally:,
        use_metadata_mappings:,
      }
    end

    def read_options
      {
        max_records:,
      }
    end

    # @param [HierarchicalEntity] entity
    # @return [Dry::Monads::Success(HarvestAttempt)]
    # @return [Dry::Monads::Success(nil)]
    def upsert_source_for!(entity)
      return Success(nil) if url.blank?

      call_operation("pilot_harvesting.upsert_source", self, entity)
    end
  end
end
