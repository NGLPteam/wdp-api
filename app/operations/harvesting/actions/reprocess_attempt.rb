# frozen_string_literal: true

module Harvesting
  module Actions
    # Reprepare and re-upsert all {HarvestEntity staged entities} from a {HarvestAttempt}.
    #
    # For now, this is a thin wrapper around {Harvesting::Actions::UpsertAllEntities}.
    class ReprocessAttempt < Harvesting::BaseAction
      include MeruAPI::Deps[
        upsert_all_entities: "harvesting.actions.upsert_all_entities",
      ]

      runner do
        param :harvest_attempt, Harvesting::Types::Attempt

        option :reprepare, Harvesting::Types::Bool, default: proc { true }
      end

      # @param [HarvestAttempt] harvest_attempt
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def perform(harvest_attempt, reprepare: true)
        yield upsert_all_entities.call(harvest_attempt, reprepare:)

        return Success()
      end
    end
  end
end
