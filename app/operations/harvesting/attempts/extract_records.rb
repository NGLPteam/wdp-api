# frozen_string_literal: true

module Harvesting
  module Attempts
    # Populates a collection of {HarvestRecord records} for an individual {HarvestAttempt attempt}.
    class ExtractRecords
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        extract_oai: "harvesting.oai.extract_records",
        extract_entities_from_record: "harvesting.records.extract_entities",
        middleware: "harvesting.attempts.middleware",
      ]

      # @param [HarvestAttempt] harvest_attempt
      # @return [Integer] the count of sets harvested
      def call(harvest_attempt)
        harvest_attempt.touch :began_at

        middleware.call(harvest_attempt) do
          yield extract_records_by_kind harvest_attempt

          harvest_attempt.harvest_records.find_each do |harvest_record|
            yield extract_entities_from_record.call harvest_record
          end
        end

        harvest_attempt.touch :ended_at

        harvest_attempt.harvest_source.touch :last_harvested_at

        Success harvest_attempt.harvest_records.count
      end

      private

      # @param [HarvestAttempt] harvest_attempt
      def extract_records_by_kind(harvest_attempt)
        case harvest_attempt.harvest_source.kind
        when "oai"
          extract_oai.call harvest_attempt
        else
          return Failure[:unknown_kind, "Cannot extract records for #{harvest_attempt.kind}"]
        end
      end
    end
  end
end
