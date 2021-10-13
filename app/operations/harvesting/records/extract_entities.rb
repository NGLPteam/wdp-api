# frozen_string_literal: true

module Harvesting
  module Records
    class ExtractEntities
      include Dry::Monads[:do, :result]
      include Dry::Effects::Handler.Resolve

      include WDPAPI::Deps[
        extract_entities_from_metadata: "harvesting.metadata.extract_entities",
      ]

      # @param [HarvestRecord] harvest_record
      # @return [void]
      def call(harvest_record)
        provide harvest_record: harvest_record do
          yield extract_entities_from_metadata.call harvest_record.raw_metadata_source
        end

        Success nil
      end
    end
  end
end
