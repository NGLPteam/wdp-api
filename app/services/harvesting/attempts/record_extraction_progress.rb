# frozen_string_literal: true

module Harvesting
  module Attempts
    # @api private
    class RecordExtractionProgress
      extend Dry::Initializer

      include Dry::Core::Equalizer.new(:attempt_id)
      include Redis::Objects
      include Shared::Typing

      param :attempt, Harvesting::Types::Attempt

      option :max_record_count, Harvesting::Types::Integer, default: proc { attempt.max_record_count }

      delegate :id, to: :attempt, prefix: true

      EXPIRATION = -> { 24.hours.from_now }

      redis_id_field :attempt_id

      counter :batches, expireat: EXPIRATION
      counter :processed, expireat: EXPIRATION
      counter :records, expireat: EXPIRATION

      def exceeded_max_records?
        processed.value >= max_record_count
      end

      # @return [void]
      def reset!
        counters.each(&:reset)
      end

      def batches!
        batches.increment
      end

      def records!(count = 0)
        records.incrby count
      end

      # @return [Boolean]
      def processed!(count = 0)
        processed.incrby count
      end

      def should_stop?
        exceeded_max_records?
      end

      private

      def counters
        [batches, processed, records]
      end
    end
  end
end
