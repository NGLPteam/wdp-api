# frozen_string_literal: true

module Types
  # @see Analytics::RegionCountResult
  class AnalyticsRegionCountResultType < Types::BaseObject
    description <<~TEXT
    A count for specific events based on the visitor's detected country and region (if available).
    TEXT

    field :country_code, String, null: false do
      description <<~TEXT
      The two-letter country code, if available. Unknown / null values will be `"$unknown$"`.
      TEXT
    end

    field :region_code, String, null: false do
      description <<~TEXT
      The shortened region code, if available. Unknown / null values will be `"$unknown$"`.
      TEXT
    end

    field :count, Integer, null: false do
      description <<~TEXT
      The count of events for the given country / region.
      TEXT
    end
  end
end
