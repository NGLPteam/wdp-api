# frozen_string_literal: true

module Types
  # @see Analytics::RegionCountSummary
  class AnalyticsRegionCountSummaryType < Types::BaseObject
    description <<~TEXT
    The summary of country/region-keyed event counts.
    TEXT

    field :results, [Types::AnalyticsRegionCountResultType, { null: false }], null: false do
      description <<~TEXT
      Individual results. They are not in any deterministic order since they are based on countries / regions.
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
