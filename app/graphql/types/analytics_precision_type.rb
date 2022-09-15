# frozen_string_literal: true

module Types
  class AnalyticsPrecisionType < Types::BaseEnum
    description <<~TEXT
    The level of precision for analytics queries.
    TEXT

    value "HOUR", value: "hour"
    value "DAY", value: "day"
    value "WEEK", value: "week"
    value "MONTH", value: "month"
    value "QUARTER", value: "quarter"
    value "YEAR", value: "year"
  end
end
