# frozen_string_literal: true

module Types
  class AnalyticsType < Types::BaseObject
    field :entity_views, Types::AnalyticsEventCountSummaryType, null: false do
      extension Analytics::Extensions::FiltersByDate
      extension Analytics::Extensions::FiltersByEntities
      extension Analytics::Extensions::FiltersByPrecision
    end

    field :entity_views_by_region, Types::AnalyticsRegionCountSummaryType, null: false do
      extension Analytics::Extensions::FiltersByDate
      extension Analytics::Extensions::FiltersByEntities
      extension Analytics::Extensions::FiltersByUnitedStatesOnly
    end

    field :asset_downloads, Types::AnalyticsEventCountSummaryType, null: false do
      extension Analytics::Extensions::FiltersByDate
      extension Analytics::Extensions::FiltersByEntities
      extension Analytics::Extensions::FiltersByPrecision
      extension Analytics::Extensions::FiltersBySubjects
    end

    field :asset_downloads_by_region, Types::AnalyticsRegionCountSummaryType, null: false do
      extension Analytics::Extensions::FiltersByDate
      extension Analytics::Extensions::FiltersByEntities
      extension Analytics::Extensions::FiltersBySubjects
      extension Analytics::Extensions::FiltersByUnitedStatesOnly
    end

    # @param [Hash] options
    # @return [Analytics::EventCountSummary]
    def asset_downloads(**options)
      resolve_analytics_event_counts("asset.download", **options)
    end

    # @param [Hash] options
    # @return [Analytics::RegionCountSummary]
    def asset_downloads_by_region(**options)
      resolve_analytics_region_counts("asset.download", **options)
    end

    # @param [Hash] options
    # @return [Analytics::EventCountSummary]
    def entity_views(**options)
      resolve_analytics_event_counts("entity.view", **options)
    end

    # @param [Hash] options
    # @return [Analytics::RegionCountSummary]
    def entity_views_by_region(**options)
      resolve_analytics_region_counts("entity.view", **options)
    end
  end
end
