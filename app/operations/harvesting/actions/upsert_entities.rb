# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert a set of {HarvestEntity staged entities} from a {HarvestRecord}.
    class UpsertEntities < Harvesting::BaseAction
      include WDPAPI::Deps[
        prepare_entities: "harvesting.actions.prepare_entities_from_record",
        upsert_entities: "harvesting.records.upsert_entities",
      ]

      runner do
        param :harvest_record, Harvesting::Types::Record

        option :reprepare, Harvesting::Types::Bool, default: proc { false }

        logs_errors_from! :harvest_record
      end

      before_perform :clear_harvest_errors!

      first_argument_provides_middleware!

      defer_ordering_refresh!

      # @param [HarvestRecord] harvest_record
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def perform(harvest_record, reprepare: false)
        if reprepare
          yield prepare_entities.call(harvest_record)

          return Success() if harvest_record.harvest_errors.any?
        end

        upsert_entities.(harvest_record)
      end
    end
  end
end
