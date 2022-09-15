# frozen_string_literal: true

module Analytics
  module FiltersByDateRange
    extend ActiveSupport::Concern

    included do
      option :date_filter, Analytics::DateFilter.for_option, default: proc { Analytics::DateFilter.new }

      before_funnel :filter_by_date_range!
    end

    # @return [void]
    def filter_by_date_range!
      augment_scope! do |scope|
        date_filter.apply_to scope, time_attribute
      end
    end
  end
end
