# frozen_string_literal: true

module Harvesting
  module Mappings
    # @see Harvesting::Mappings::ScheduleAttempts
    class AttemptsScheduler < Support::HookBased::Actor
      include Dry::Core::Constants
      include Dry::Initializer[undefined: false].define -> do
        param :harvest_mapping, Harvesting::Types::Mapping

        option :occurrences_count, Harvesting::Schedules::Types::OccurrencesCount, default: proc { 10 }

        option :start_time, Harvesting::Types::Time, default: proc { Time.current.at_beginning_of_day }
      end

      standard_execution!

      delegate :frequency_expression, :scheduled?, to: :harvest_mapping

      # @return [<HarvestAttempt>]
      attr_reader :attempts

      # @return [<Harvesting::Schedules::Occurrence>]
      attr_reader :occurrences

      # @return [ActiveSupport::TimeWithZone]
      attr_reader :start_time

      # @return [Dry::Monads::Success(HarvestMapping)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield schedule!

          yield cancel_unknown!
        end

        harvest_mapping.touch(:last_scheduled_at)

        Success harvest_mapping
      end

      wrapped_hook! def prepare
        @attempts = []

        @occurrences = scheduled? ? Harvesting::Schedules::Occurrences.fetch(frequency_expression, start_time:) : EMPTY_ARRAY

        super
      end

      wrapped_hook! def schedule
        @attempts = occurrences.map do |occurrence|
          yield harvest_mapping.create_attempt(occurrence:, kind: "scheduled")
        end

        super
      end

      wrapped_hook! def cancel_unknown
        scheduling_key = occurrences.map { _1.scheduling_key }

        harvest_mapping.harvest_attempts.scheduled_in_the_future.where.not(scheduling_key:).find_each do |attempt|
          attempt.transition_to :cancelled
        end

        super
      end
    end
  end
end
