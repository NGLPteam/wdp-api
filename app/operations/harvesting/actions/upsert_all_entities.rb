# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert all {HarvestEntity staged entities} from a {HarvestAttempt}.
    class UpsertAllEntities < Harvesting::BaseAction
      include WDPAPI::Deps[
        upsert_entities: "harvesting.actions.upsert_entities"
      ]

      runner do
        param :harvest_attempt, Harvesting::Types::Attempt

        option :reprepare, Harvesting::Types::Bool, default: proc { false }
      end

      first_argument_provides_middleware!

      # @param [HarvestAttempt] harvest_attempt
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def perform(harvest_attempt, reprepare: false)
        harvest_attempt.harvest_records.find_each do |harvest_record|
          yield upsert_entities.call(harvest_record, reprepare: reprepare)
        end

        return Success()
      end
    end
  end
end
