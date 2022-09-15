# frozen_string_literal: true

module Types
  # @see Analytics::DateFilter
  class DateFilterInputType < Types::BaseInputObject
    description <<~TEXT
    A date-filter for various analytics and other resolvers.
    TEXT

    argument :start_date, GraphQL::Types::ISO8601Date, required: false do
      description <<~TEXT
      The start date. Make sure it is <= `end_date` if provided.

      For actual filtering, this will get turned into midnight in the provided `time_zone`.
      TEXT
    end

    argument :end_date, GraphQL::Types::ISO8601Date, required: false do
      description <<~TEXT
      The end date. Make sure it is >= `start_date` if provided.

      For actual filtering, this will get turned into 23:59:59 in the provided `time_zone`.
      TEXT
    end

    argument :time_zone, String, required: false do
      description <<~TEXT
      The time zone to use for calculating the range.

      If not provided, it will use the server's configured default,
      which is at present UTC, but may be configurable later on.
      TEXT
    end

    # @return [Analytics::DateFilter]
    def prepare
      Analytics::DateFilter.new(to_h)
    end
  end
end
