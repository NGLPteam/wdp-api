# frozen_string_literal: true

module Analytics
  module FunnelsByDatePrecision
    extend ActiveSupport::Concern

    include Analytics::FiltersByDateRange

    included do
      option :precision, Analytics::Types::Precision, default: proc { "day" }
    end

    def funnel!
      funnel_by_group_date!

      funnel_to_results!

      funnel_to_summary!
    end

    private

    # @return [void]
    def funnel_by_group_date!
      augment_scope! do |scope|
        options = date_filter.to_groupdate_options
        options[:permit] = Analytics::Types::Precision.values

        scope.group_by_period(precision, time_column, **options).count
      end
    end

    # @return [void]
    def funnel_to_results!
      augment_scope! do |scope|
        scope.map do |datelike, count|
          attrs = { count: }

          case precision
          when "hour"
            attrs[:time] = datelike
            attrs[:date] = datelike.in_time_zone(date_filter.time_zone).to_date
          else
            attrs[:date] = datelike
          end

          Analytics::EventCountResult.new(attrs)
        end
      end
    end

    def funnel_to_summary!
      augment_scope! do |results|
        min_date, max_date = results.pluck(:date).minmax

        attrs = {
          min_date:,
          max_date:,
          precision:,
          results:,
          unfiltered_total: unfiltered_count,
        }

        attrs[:total] = results.sum(&:count)

        Analytics::EventCountSummary.new(attrs)
      end
    end
  end
end
