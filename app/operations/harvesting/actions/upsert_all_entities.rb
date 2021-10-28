# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert all {HarvestEntity staged entities} from a {HarvestAttempt}.
    class UpsertAllEntities < Harvesting::BaseAction
      include WDPAPI::Deps[
        upsert_entities: "harvesting.actions.upsert_entities"
      ]

      prepend Harvesting::HushActiveRecord

      # @param [HarvestAttempt] harvest_attempt
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def call(harvest_attempt, reprepare: false)
        wrap_middleware.call(harvest_attempt) do
          silence_activerecord do
            harvest_attempt.harvest_records.find_each do |harvest_record|
              yield upsert_entities.call(harvest_record, reprepare: reprepare)
            end
          end
        end

        Success nil
      end
    end
  end
end
