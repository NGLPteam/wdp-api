# frozen_string_literal: true

module Harvesting
  module Sources
    # Extract sets synchronously in a single request.
    #
    # @see Harvesting::Protocols::SetExtractor
    # @see Harvesting::Sources::ExtractSetsJob
    class ExtractSets
      include Dry::Monads[:result, :do]

      # @param [HarvestSource] harvest_source
      # @return [Dry::Monads::Success(:supported)]
      # @return [Dry::Monads::Success(:unsupported)]
      def call(harvest_source)
        context = harvest_source.build_protocol_context

        yield context.extract_sets

        Success(:supported)
      rescue Harvesting::Protocols::SetExtractionUnsupported
        # In the event it's unsupported, just treat this as an empty success.
        Success(:unsupported)
      end
    end
  end
end
