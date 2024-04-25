# frozen_string_literal: true

module Harvesting
  module Metadata
    # An interface for declaring rules for extracting values from a data source
    # based on a flexible candidate / parsing DSL.
    module ExtractsValues
      extend ActiveSupport::Concern
      extend Shared::Typing

      include Dry::Core::Memoizable
      include Harvesting::Metadata::ValueExtraction::GeneratesErrors

      included do
        extend Dry::Core::ClassAttributes
        extend ActiveModel::Callbacks

        # @!scope class
        # @!attribute [r] value_extractor
        # The value extraction definition for this class.
        # @see .extract_values!
        # @return [Harvesting::Metadata::ValueExtraction::Extractor]
        defines :value_extractor, type: Harvesting::Metadata::ValueExtraction::Extractor::Type

        value_extractor Harvesting::Metadata::ValueExtraction::Extractor.empty

        define_model_callbacks :value_extraction
      end

      # Extract values based on the class' definition.
      #
      # @return [Dry::Monads::Success(Harvesting::Metadata::ValueExtraction::Struct)]
      def extract_values
        run_callbacks :value_extraction do
          self.class.value_extractor.call(self)
        end
      end

      # @abstract
      # @api private
      # @param [Harvesting::Metadata::ValueExtraction::Context] context
      # @return [void]
      def enhance_extraction_context(context); end

      class_methods do
        # Using a DSL, allow this class to define values to be extracted from itself as a data source.
        #
        # It supports multiple candidates, and automatically generates a struct for simpler access.
        #
        # @see Harvesting::Metadata::ValueExtraction::DSL::Builder
        # @return [void]
        def extract_values!(&)
          extractor = Harvesting::Metadata::ValueExtraction::DSL::Builder.new(self).build(&)

          value_extractor extractor
        end

        # Declare that this class should memoize its value extraction
        #
        # @!macro [attach] memoize_value_extraction!
        #   @!parse [ruby]
        #     include Harvesting::Metadata::ExtractsValues::MemoizesValueExtraction
        # @return [void]
        def memoize_value_extraction!
          include MemoizesValueExtraction
        end
      end

      # An interface for memoized value extraction.
      #
      # @api private
      # @see Harvesting::Metadata::ExtractsValues.memoize_value_extraction!
      module MemoizesValueExtraction
        extend ActiveSupport::Concern

        # @!attribute [r] extracted_values
        # @return [Dry::Monads::Success(Harvesting::Metadata::ValueExtraction::Struct)]
        def extracted_values
          @extracted_values ||= extract_values
        end
      end
    end
  end
end
