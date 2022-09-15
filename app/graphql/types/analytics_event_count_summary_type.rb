# frozen_string_literal: true

module Types
  # @see Analytics::EventCountSummary
  class AnalyticsEventCountSummaryType < Types::BaseObject
    description <<~TEXT
    The summary of date-keyed event counts.
    TEXT

    field :min_date, GraphQL::Types::ISO8601Date, null: true do
      description "The oldest date in the set of results (if present)."
    end

    field :max_date, GraphQL::Types::ISO8601Date, null: true do
      description "The newest date in the set of results (if present)."
    end

    field :precision, Types::AnalyticsPrecisionType, null: false do
      description "The level of precision requested"
    end

    field :results, [Types::AnalyticsEventCountResultType, { null: false }], null: false do
      description <<~TEXT
      Individual results. They are sorted in ascending date / time order.
      TEXT
    end

    field :total, Integer, null: false do
      description <<~TEXT
      The filtered total of events in the date period.
      TEXT
    end

    field :unfiltered_total, Integer, null: false do
      description <<~TEXT
      The unfiltered total of events across the entire system (excluding date filters, but including all other filters).
      TEXT
    end
  end
end
