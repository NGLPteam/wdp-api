# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    class BaseProtocol
      extend Dry::Core::ClassAttributes

      include Dry::Core::Equalizer.new(:protocol_name)

      include Dry::Monads[:result]
      include MeruAPI::Deps[
        augment_middleware: "harvesting.protocols.actions.augment_middleware",
        process_record_batch: "harvesting.protocols.actions.process_record_batch",
      ]

      defines :protocol_name, type: Harvesting::Types::String

      protocol_name "Unknown"

      # @abstract
      # @return [#call]
      def extract_raw_metadata
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @abstract
      # @return [#call]
      def extract_raw_source
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @abstract
      # @return [#call]
      def extract_record
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @abstract
      # @return [#call]
      def extract_records
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @abstract
      # @return [#call]
      def extract_sets
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @abstract
      # @return [#call]
      def process_record
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @abstract
      # @return [#call]
      def record_identifier
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:protocol, protocol_name, __method__)
        # :nocov:
      end

      # @!attribute [r] protocol_name
      # @return [String]
      def protocol_name
        self.class.protocol_name
      end

      def to_monad
        Success self
      end
    end
  end
end
