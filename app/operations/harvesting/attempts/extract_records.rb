# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see Harvesting::Actions::ExtractRecords
    class ExtractRecords
      include Dry::Monads[:result]
      include Dry::Effects.Resolve(:protocol)
      include Dry::Effects::Handler.Interrupt(:no_records, as: :catch_no_records)

      include Dry::Monads::Do.for(:call)

      # @param [HarvestAttempt] harvest_attempt
      # @return [Dry::Monads::Success(Integer)] the count of records harvested
      def call(harvest_attempt)
        harvest_attempt.clear_harvest_errors!

        with_stack do
          yield protocol.extract_records.(harvest_attempt)
        end

        Success harvest_attempt.harvest_records.count
      end

      private

      def with_stack
        with_no_records do
          yield
        end
      end

      # @return [void]
      def with_no_records
        interrupted, _ = catch_no_records do
          yield
        end

        logger.log "No records to extract" if interrupted
      end
    end
  end
end
