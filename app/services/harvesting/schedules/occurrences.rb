# frozen_string_literal: true

module Harvesting
  module Schedules
    # @api private
    class Occurrences
      include Dry::Initializer[undefined: false].define -> do
        param :frequency_expression, Harvesting::Schedules::Types::FrequencyExpression

        option :occurrences_count, Harvesting::Schedules::Types::OccurrencesCount, default: proc { 10 }

        option :start_time, Harvesting::Schedules::Types::Time, default: proc { Time.current }
      end

      def initialize(...)
        super

        @fugit = Fugit.parse_cronish(frequency_expression) if frequency_expression.present?

        @too_soon = Time.current.at_beginning_of_hour + 50.minutes
      end

      # @return [Enumerator::Lazy<Harvesting::Schedules::Occurence>]
      def to_enumerator
        to_enum(:iterate).lazy
      end

      private

      # @param [ActiveSupport::TimeWithZone] scheduled_at
      # @return [Harvesting::Schedules::Occurrence]
      def build_occurrence(scheduled_at)
        Harvesting::Schedules::Occurrence.new(frequency_expression:, scheduled_at:)
      end

      def iterate
        return if @fugit.blank?

        iter_count = 0

        last_time = start_time

        loop do
          break unless iter_count < occurrences_count

          scheduled_at = last_time = @fugit.next_time(last_time).to_t.in_time_zone

          next if scheduled_at < @too_soon

          occurrence = build_occurrence(scheduled_at)

          yield occurrence

          iter_count += 1
        end
      end

      class << self
        def build(...)
          new(...).to_enumerator
        end

        def fetch(...)
          build(...).to_a
        end
      end
    end
  end
end
