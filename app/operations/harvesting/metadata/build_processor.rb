# frozen_string_literal: true

module Harvesting
  module Metadata
    class BuildProcessor
      include Dry::Monads[:result]

      # @param [HarvestSource] harvest_source
      # @return [Harvesting::Metadata::AbstractProcessor]
      def call(harvest_source)
        source_format = harvest_source.source_format

        case source_format
        when "mods"
          Success Harvesting::Metadata::ModsProcessor.new harvest_source
        else
          Failure[:unknown_metadata_format, "Cannot process metadata format: #{source_format}"]
        end
      end
    end
  end
end
