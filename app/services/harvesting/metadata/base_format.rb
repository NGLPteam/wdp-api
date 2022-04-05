# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class BaseFormat
      extend Dry::Core::ClassAttributes

      include Dry::Monads[:result]
      include WDPAPI::Deps[
        augment_middleware: "harvesting.metadata.actions.augment_middleware",
        validate_raw_metadata: "harvesting.metadata.actions.validate_raw_metadata",
      ]

      defines :format, :format_name, :oai_metadata_prefix, type: Dry::Types["coercible.string"]

      # @abstract
      # @return [#call]
      def extract_entities
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:metadata_format, format_name, __method__)
        # :nocov:
      end

      # @!attribute [r] format
      # @return [String]
      def format
        self.class.format
      end

      # @!attribute [r] format_name
      # @return [String]
      def format_name
        self.class.format_name
      end

      # The prefix to use with OAI.
      #
      # @!attribute [r] oai_metadata_prefix
      # @return [String]
      def oai_metadata_prefix
        self.class.oai_metadata_prefix
      end

      # @abstract
      # @return [#call]
      def parse
        # :nocov:
        Harvesting::Utility::UnavailableAction.new(:metadata_format, format_name, __method__)
        # :nocov:
      end

      # @return [Dry::Monads::Result]
      def to_monad
        Success self
      end

      class << self
        def inherited(subclass)
          super if defined?(super)

          subclass.format_name subclass.name.demodulize
          subclass.format subclass.format_name.parameterize
          subclass.oai_metadata_prefix subclass.format_name.parameterize
        end
      end
    end
  end
end
