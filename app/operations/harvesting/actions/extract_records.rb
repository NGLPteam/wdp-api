# frozen_string_literal: true

module Harvesting
  module Actions
    # Populates a collection of {HarvestRecord records} for an individual {HarvestAttempt attempt},
    # based on the protocol.
    class ExtractRecords < Harvesting::BaseAction
      include WDPAPI::Deps[
        extract_records: "harvesting.attempts.extract_records",
        prepare_entities_from_record: "harvesting.actions.prepare_entities_from_record",
      ]

      runner do
        param :harvest_attempt, Harvesting::Types::Attempt

        option :async, Harvesting::Types::Bool, default: proc { false }

        option :cursor, Harvesting::Types::String.optional, default: proc {}

        option :skip_prepare, Harvesting::Types::Bool, default: proc { false }

        delegate :harvest_source, to: :harvest_attempt

        # @return [void]
        def track!
          harvest_attempt.touch :began_at

          yield

          harvest_source.touch :last_harvested_at
        ensure
          harvest_attempt.touch :ended_at
        end
      end

      extract_middleware_from :harvest_attempt

      around_perform :track_attempt_time!

      # @param [HarvestAttempt] harvest_attempt
      # @return [Dry::Monads::Success(Integer)] the count of records harvested
      def perform(harvest_attempt, async: false, cursor: nil, skip_prepare: false)
        record_count = yield extract_records.(harvest_attempt, async: async, cursor: cursor)

        harvest_attempt.harvest_records.find_each do |harvest_record|
          yield prepare_entities_from_record.call harvest_record
        end unless skip_prepare || async

        Success record_count
      end

      private

      # @return [void]
      def track_attempt_time!
        runner.track! do
          yield
        end
      end
    end
  end
end
