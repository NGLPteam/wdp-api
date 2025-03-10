# frozen_string_literal: true

module Harvesting
  module Frozen
    module HasProtocolAndMetadata
      extend ActiveSupport::Concern

      included do
        extend Dry::Core::ClassAttributes

        defines :protocol_optional, :metadata_format_optional, type: Harvesting::Types::Bool

        protocol_optional false
        metadata_format_optional false

        add_index :protocol_name
        add_index :metadata_format_name

        HarvestProtocol.pluck(:name).each do |name|
          scope name.to_sym, -> { by_protocol(name) }
        end

        HarvestMetadataFormat.pluck(:name).each do |name|
          scope name.to_sym, -> { by_metadata_format(name) }
        end

        calculates! :oai do |record|
          record["protocol_name"] == "oai"
        end

        calculates! :protocol do |record|
          HarvestProtocol.find(record["protocol_name"])
        rescue FrozenRecord::RecordNotFound => e
          raise e unless protocol_optional
        end

        calculates! :metadata_format do |record|
          HarvestMetadataFormat.find(record["metadata_format_name"])
        rescue FrozenRecord::RecordNotFound => e
          raise e unless metadata_format_optional
        end
      end

      module ClassMethods
        # @return [void]
        def protocol_optional!
          protocol_optional true
        end

        def metadata_format_optional!
          metadata_format_optional true
        end

        # @return [void]
        def protocol_and_metadata_optional!
          protocol_optional!

          metadata_format_optional!
        end

        # @param [Harvesting::Types::ProtocolName] value
        # @return [FrozenRecord::Scope]
        def by_protocol(value)
          return all if value.blank?

          protocol_name = ::Harvesting::Types::ProtocolName[value]

          where(protocol_name:)
        end

        # @param [Harvesting::Types::MetadataFormatName] value
        # @return [FrozenRecord::Scope]
        def by_metadata_format(value)
          return all if value.blank?

          metadata_format_name = ::Harvesting::Types::MetadataFormatName[value]

          where(metadata_format_name:)
        end
      end
    end
  end
end
