# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    class Context
      extend ActiveModel::Callbacks

      include ::Utility::DefinesAbstractMethods
      include Harvesting::WithLogger
      include Dry::Effects.Interrupt(:check_failed)
      include Dry::Core::Equalizer.new(:protocol_name, :base_url, :harvest_source_id)
      include Dry::Monads[:result]
      include Dry::Initializer[undefined: false].define -> do
        param :protocol, Harvesting::Types.Instance(::HarvestProtocol)

        param :harvest_source, Harvesting::Types::Source
      end

      delegate :name, to: :protocol, prefix: true
      delegate :base_url, to: :harvest_source
      delegate :id, to: :harvest_source, prefix: :source
      delegate :supports_extract_sets?, to: :protocol

      define_model_callbacks :initialize, only: %i[after]

      # @return [HarvestMetadataFormat]
      attr_reader :default_metadata_format

      # @return [Harvesting::Protocols::RecordExtractor]
      attr_reader :extract_record

      # @return [Harvesting::Protocols::RecordProcessor]
      attr_reader :process_record

      # @return [Harvesting::Protocols::RecordBatchProcessor]
      attr_reader :process_record_batch

      def initialize(...)
        run_callbacks :initialize do
          super

          set_up!
        end
      end

      # @return [Dry::Monads::Success(void)]
      def extract_records_for(...)
        batch_extractor = batch_extractor_for(...)

        batch_extractor.()
      end

      # @return [Dry::Monads::Success(void)]
      def extract_sets
        set_extractor = set_extractor_for(cursor: nil)

        set_extractor.()
      end

      # @return [Enumerator::Lazy<(HarvestRecord, String)>]
      def record_enumerator_for(...)
        batch_extractor = batch_extractor_for(...)

        batch_extractor.to_enumerator
      end

      def set_enumerator_for(...)
        set_extractor = set_extractor_for(...)

        set_extractor.to_enumerator
      end

      abstract_method! :perform_check!

      abstract_method! :deleted?, signature: "record"

      abstract_method! :extract_raw_metadata, signature: "record"

      abstract_method! :extract_raw_source, signature: "record"

      abstract_method! :record_identifier, signature: "record"

      # @abstract
      # @param [Object] raw_record
      def skip?(raw_record)
        raw_record.blank?
      end

      private

      def batch_extractor_for(...)
        protocol.record_batch_extractor_klass.new(...)
      end

      # @param [String] message
      # @return [void]
      def check_failed_because!(message)
        logger.fatal message, tags: %w[status_check_failed]

        check_failed
      end

      def set_extractor_for(cursor: nil)
        raise Harvesting::Protocols::SetExtractionUnsupported, "#{protocol_name} protocol does not support extracting sets." unless supports_extract_sets?

        protocol.set_extractor_klass.new(harvest_source, cursor:)
      end

      # A part of initialization that runs within the `initialize` callback stack,
      # but in particular _before_ `after_initialize` callbacks.
      #
      # @return [void]
      def set_up!
        @default_metadata_format = HarvestMetadataFormat.find harvest_source.metadata_format

        @extract_record = protocol.record_extractor_klass.new(self)

        @process_record = protocol.record_processor_klass.new(self)

        @process_record_batch = protocol.record_batch_processor_klass.new(self)
      end
    end
  end
end
