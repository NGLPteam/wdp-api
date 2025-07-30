# frozen_string_literal: true

module Harvesting
  module Metadata
    # @abstract
    class Context
      extend ActiveModel::Callbacks

      include Dry::Effects::Handler.Reader(:parent_metadata_context)

      include Dry::Initializer[undefined: false].define -> do
        param :metadata_format, Harvesting::Metadata::Types.Instance(::HarvestMetadataFormat)

        param :harvest_record, Harvesting::Metadata::Types::HarvestRecord
      end

      define_model_callbacks :initialize, only: %i[after]
      define_model_callbacks :setup
      define_model_callbacks :assigns, :configuration

      around_configuration :provide_metadata_context!

      # @return [{ String => Object }]
      attr_reader :assigns

      # The cleaned-up (if necessary) metadata source.
      # @return [String]
      attr_reader :metadata_source

      def initialize(...)
        run_callbacks :initialize do
          super

          set_up!
        end

        run_callbacks :configuration do
          build_assigns!
        end
      end

      private

      # @abstract
      # @param [String] raw
      # @return [String]
      def clean_up_metadata_source(raw)
        case metadata_format.underlying_data_format
        in "json"
          raw
        else
          raw.to_s
        end
      end

      def build_drop(drop_klass, *args, **kwargs)
        kwargs[:metadata_context] = self

        drop_klass.new(*args, **kwargs)
      end

      # @return [void]
      def build_assigns!
        @assigns = {}.with_indifferent_access

        run_callbacks :assigns do
          build_common_assigns!
        end

        @assigns.freeze
      end

      ## @return [void]
      def build_common_assigns!
        @assigns[:record] = Harvesting::Drops::Record.new(harvest_record)
      end

      # @return [void]
      def provide_metadata_context!
        with_parent_metadata_context self do
          yield
        end
      end

      # A part of initialization that runs within the `initialize` callback stack,
      # but in particular _before_ `after_initialize` callbacks.
      #
      # @return [void]
      def set_up!
        @metadata_source = clean_up_metadata_source(harvest_record.raw_metadata_source)
      end
    end
  end
end
