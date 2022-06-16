# frozen_string_literal: true

module Harvesting
  module Actions
    class ManuallyRunSource < Harvesting::BaseAction
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        create_manual_attempt: "harvesting.sources.create_manual_attempt",
        extract_records: "harvesting.actions.extract_records",
      ]

      deferred_ordering_refresh true

      runner do
        param :harvest_source, Harvesting::Types::Source
        param :harvest_target, Harvesting::Types::Target

        option :set, Harvesting::Types::Set.optional, default: proc {}

        option :skip_harvest, Harvesting::Types::Bool, default: proc { false }
      end

      # @param [HarvestSource] harvest_source
      # @param [HarvestTarget] target_entity
      # @param [HarvestSet, nil] set
      # @return [Dry::Monads::Success(HarvestAttempt)]
      def perform(harvest_source, target_entity, set: nil, skip_harvest: false)
        attempt = yield create_manual_attempt.call harvest_source, target_entity, set: set

        Harvesting::ExtractRecordsJob.perform_later attempt unless skip_harvest

        Success attempt
      end
    end
  end
end
