# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    class BaseProtocol
      extend Dry::Core::ClassAttributes

      include Dry::Monads[:result]
      include WDPAPI::Deps[
        augment_middleware: "harvesting.protocols.actions.augment_middleware",
      ]

      defines :protocol_name, type: AppTypes::String

      protocol_name "Unknown"

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

      # @!attribute [r] protocol_name
      # @return [String]
      def protocol_name
        self.class.protocol.name
      end

      def to_monad
        Success self
      end
    end
  end
end
