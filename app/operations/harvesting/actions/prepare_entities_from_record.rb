# frozen_string_literal: true

module Harvesting
  module Actions
    # Extract a set of {HarvestEntity staged entities} from a {HarvestRecord},
    # to be upserted later.
    class PrepareEntitiesFromRecord < Harvesting::BaseAction
      include Dry::Effects.Resolve(:metadata_format)
      include WDPAPI::Deps[
        update_entity_count: "harvesting.records.update_entity_count",
      ]

      prepend Harvesting::HushActiveRecord

      def call(harvest_record)
        wrap_middleware.call(harvest_record) do
          silence_activerecord do
            yield metadata_format.extract_entities.call harvest_record.raw_metadata_source
          end
        end

        yield update_entity_count.call(harvest_record)

        Success nil
      end
    end
  end
end
