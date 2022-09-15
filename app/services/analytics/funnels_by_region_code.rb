# frozen_string_literal: true

module Analytics
  module FunnelsByRegionCode
    extend ActiveSupport::Concern

    include Analytics::FiltersByDateRange
    include Analytics::FiltersByUnitedStatesOnly

    def funnel!
      funnel_by_region_code!

      funnel_to_results!

      funnel_to_summary!
    end

    private

    # @return [void]
    def funnel_by_region_code!
      augment_scope! do |scope|
        scope.group(
          Ahoy::Visit.arel_table[:country_code],
          Ahoy::Visit.arel_table[:region_code]
        ).count
      end
    end

    # @return [void]
    def funnel_to_results!
      augment_scope! do |scope|
        scope.map do |(country_code, region_code), count|
          attrs = {
            count: count,
            country_code: country_code,
            region_code: region_code
          }.compact_blank

          Analytics::RegionCountResult.new(attrs)
        end
      end
    end

    def funnel_to_summary!
      augment_scope! do |results|
        attrs = {
          results: results,
          unfiltered_total: unfiltered_count,
        }

        attrs[:total] = results.sum(&:count)

        Analytics::RegionCountSummary.new(attrs)
      end
    end
  end
end
