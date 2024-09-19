# frozen_string_literal: true

module Harvesting
  module Actions
    class ManuallyRunMapping < Harvesting::BaseAction
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        create_manual_attempt: "harvesting.mappings.create_manual_attempt",
        extract_records: "harvesting.actions.extract_records",
      ]

      deferred_ordering_refresh true

      runner do
        param :harvest_mapping, Harvesting::Types::Mapping

        option :skip_harvest, Harvesting::Types::Bool, default: proc { false }
      end

      # @param [HarvestMapping] harvest_mapping
      # @return [Dry::Monads::Result]
      def perform(harvest_mapping, skip_harvest: false)
        attempt = yield create_manual_attempt.call harvest_mapping

        Harvesting::ExtractRecordsJob.perform_later attempt unless skip_harvest

        Success attempt
      end
    end
  end
end
