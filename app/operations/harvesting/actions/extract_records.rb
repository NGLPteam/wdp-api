# frozen_string_literal: true

module Harvesting
  module Actions
    # Populates a collection of {HarvestRecord records} for an individual {HarvestAttempt attempt},
    # based on the protocol.
    class ExtractRecords < Harvesting::BaseAction
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:protocol)
      include WDPAPI::Deps[
        prepare_entities_from_record: "harvesting.actions.prepare_entities_from_record",
      ]

      prepend Harvesting::HushActiveRecord

      # @param [HarvestAttempt] harvest_attempt
      # @return [Integer] the count of records harvested
      def call(harvest_attempt, skip_prepare: false)
        harvest_attempt.touch :began_at

        wrap_middleware.call harvest_attempt do
          silence_activerecord do
            yield protocol.extract_records.call harvest_attempt

            harvest_attempt.harvest_records.find_each do |harvest_record|
              yield prepare_entities_from_record.call harvest_record
            end unless skip_prepare
          end
        end

        harvest_attempt.touch :ended_at

        harvest_attempt.harvest_source.touch :last_harvested_at

        Success harvest_attempt.harvest_records.count
      end
    end
  end
end
