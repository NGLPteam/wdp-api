# frozen_string_literal: true

module Harvesting
  module Actions
    class ManuallyRunMapping < Harvesting::BaseAction
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        create_manual_attempt: "harvesting.mappings.create_manual_attempt",
        extract_records: "harvesting.actions.extract_records",
      ]

      # @param [HarvestMapping] harvest_mapping
      # @return [Dry::Monads::Result]
      def perform(harvest_mapping)
        attempt = yield create_manual_attempt.call harvest_mapping

        yield extract_records.call attempt

        attempt.harvest_records.find_each do |record|
          Harvesting::UpsertEntitiesForRecordJob.perform_later record
        end

        Success attempt
      end
    end
  end
end
