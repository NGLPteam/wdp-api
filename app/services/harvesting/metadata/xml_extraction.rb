# frozen_string_literal: true

module Harvesting
  module Metadata
    # A combination of {Harvesting::Metadata::ExtractsValues} with {Harvesting::XMLManipulation}.
    module XMLExtraction
      extend ActiveSupport::Concern

      include Harvesting::Metadata::ExtractsValues
      include Harvesting::XMLManipulation

      # @note Registers the namespaces for this XML parser in the extraction context.
      # @param [Harvesting::Metadata::ValueExtraction::Context] ctx
      # @return [void]
      def enhance_extraction_context(ctx)
        super if defined?(super)

        ctx.register :namespaces, memoize: false do
          current_namespaces
        end
      end
    end
  end
end
