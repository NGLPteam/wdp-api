# frozen_string_literal: true

module Types
  # @see Harvesting::Schedules::Data
  class HarvestScheduleDataType < Types::BaseObject
    field :cron_expression, String, null: true do
      description <<~TEXT
      The frequency expression as a cron statement, regardless
      of its original syntax.
      TEXT
    end

    field :frequency_min, GraphQL::Types::ISO8601Duration, null: true do
      description <<~TEXT
      The minimum frequency between occurrences, expressed as a duration.
      TEXT
    end

    field :frequency_max, GraphQL::Types::ISO8601Duration, null: true do
      description <<~TEXT
      The maximum frequency between occurrences, expressed as a duration.
      TEXT
    end

    field :time_zone, String, null: true do
      description <<~TEXT
      If the frequency expression included time zone information,
      this will expose which time zone is being used. Otherwise,
      the frequency will use the Meru installation time zone.
      TEXT
    end
  end
end
