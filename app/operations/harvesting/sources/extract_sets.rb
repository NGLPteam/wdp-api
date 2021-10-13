# frozen_string_literal: true

module Harvesting
  module Sources
    # Populates a collection of {HarvestSet sets} for an individual {HarvestSource source}.
    class ExtractSets
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        extract_oai: "harvesting.oai.extract_sets",
        middleware: "harvesting.sources.middleware",
      ]

      # @param [HarvestSource] harvest_source
      # @return [Integer] the count of sets harvested
      def call(harvest_source)
        middleware.call(harvest_source) do
          yield extract_sets_by_kind harvest_source
        end

        harvest_source.touch :sets_refreshed_at

        Success harvest_source.harvest_sets.count
      end

      private

      # @param [HarvestSource] harvest_source
      def extract_sets_by_kind(harvest_source)
        case harvest_source.kind
        when "oai"
          extract_oai.call harvest_source
        else
          return Failure[:unknown_kind, "Cannot extract sets for #{harvest_source.kind}"]
        end
      end
    end
  end
end
