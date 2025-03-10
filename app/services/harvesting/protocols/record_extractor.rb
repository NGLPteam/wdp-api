# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    #
    # Extract a single record for a given protocol.
    class RecordExtractor
      include Dry::Monads[:do, :result]
      include Harvesting::WithLogger
      include Dry::Effects::Handler.Reader(:metadata_format)
      include Dry::Effects.Reader(:metadata_format)
      include Dry::Initializer[undefined: false].define -> do
        param :protocol, Harvesting::Types.Instance(::Harvesting::Protocols::Context)
      end

      delegate :default_metadata_format, to: :protocol
      delegate :name, to: :default_metadata_format, prefix: true

      # @param [String] identifier
      # @param [Harvesting::Types::MetadataFormatName] metadata_format_name
      # @return [Dry::Monads::Success(HarvestRecord)]
      def call(identifier, metadata_format_name = default_metadata_format_name)
        metadata_format = HarvestMetadataFormat.find(metadata_format_name)

        with_metadata_format metadata_format do
          extracted = yield extract identifier

          return Success(nil) if extracted.blank?

          protocol.process_record.(extracted)
        end
      end

      private

      # @abstract
      # @param [String] identifier
      # @return [Dry::Monads::Result]
      def extract(identifier); end
    end
  end
end
