# frozen_string_literal: true

module Types
  # @see Analytics::EventCountResult
  class AnalyticsEventCountResultType < Types::BaseObject
    description <<~TEXT
    A simple, date/time-keyed representation of a specific event's
    occurrences on a specific day (or time interval).
    TEXT

    field :date, GraphQL::Types::ISO8601Date, null: false

    field :time, GraphQL::Types::ISO8601DateTime, null: true do
      description <<~TEXT
      The time interval associated with this value. It will only
      be populated when looking at `HOUR` precision.
      TEXT
    end

    field :count, Integer, null: false do
      description <<~TEXT
      The count of events for the given date / time.
      TEXT
    end
  end
end
