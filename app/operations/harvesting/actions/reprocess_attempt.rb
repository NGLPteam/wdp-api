# frozen_string_literal: true

module Harvesting
  module Actions
    # Reprepare and re-upsert all {HarvestEntity staged entities} from a {HarvestAttempt}.
    #
    # For now, this is a thin wrapper around {Harvesting::Actions::UpsertAllEntities}.
    class ReprocessAttempt < Harvesting::BaseAction
      include WDPAPI::Deps[
        upsert_all_entities: "harvesting.actions.upsert_all_entities",
      ]

      prepend Harvesting::HushActiveRecord

      # @param [HarvestAttempt] harvest_attempt
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def call(harvest_attempt, reprepare: true)
        yield upsert_all_entities.call harvest_attempt, reprepare: reprepare

        Success nil
      end
    end
  end
end
