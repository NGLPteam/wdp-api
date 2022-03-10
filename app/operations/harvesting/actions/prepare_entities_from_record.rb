# frozen_string_literal: true

module Harvesting
  module Actions
    # Extract a set of {HarvestEntity staged entities} from a {HarvestRecord}, to be upserted later.
    #
    # @see Harvesting::Records::PrepareEntities
    class PrepareEntitiesFromRecord < Harvesting::BaseAction
      include WDPAPI::Deps[
        prepare_entities: "harvesting.records.prepare_entities",
      ]

      runner do
        param :harvest_record, Harvesting::Types::Record

        logs_errors_from! :harvest_record
      end

      before_perform :clear_harvest_errors!

      first_argument_provides_middleware!

      defer_ordering_refresh!

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def perform(harvest_record)
        prepare_entities.(harvest_record)
      end
    end
  end
end
