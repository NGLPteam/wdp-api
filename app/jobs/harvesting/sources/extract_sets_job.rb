# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Protocols::SetExtractor
    class ExtractSetsJob < ApplicationJob
      include JobIteration::Iteration

      queue_as :extraction

      discard_on Harvesting::Protocols::SetExtractionUnsupported

      # @param [HarvestSource] harvest_source
      # @return [void]
      def build_enumerator(harvest_source, cursor:)
        protocol = harvest_source.build_protocol_context

        enum = protocol.set_enumerator_for(cursor:)

        # @see https://github.com/Shopify/job-iteration/blob/2065db0bbd461a990e13aa9bb56f86da294c584c/lib/job-iteration/enumerator_builder.rb#L42
        enumerator_builder.wrap(enumerator_builder, enum)
      end

      # @param [HarvestSet] harvest_set
      # @param [HarvestSource] _harvest_source
      # @return [void]
      def each_iteration(harvest_set, _harvest_source)
        # Intentionally left blank, we just use job-iteration to support resumable enumeration
        # during the extraction process.
      end
    end
  end
end
