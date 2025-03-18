# frozen_string_literal: true

module Harvesting
  module Schedules
    # @see ::Types::HarvestScheduleDataType
    class Data
      include Support::EnhancedStoreModel

      attribute :cron_expression, :string

      attribute :frequency_min, :interval, precision: 0

      attribute :frequency_max, :interval, precision: 0

      attribute :time_zone, :string
    end
  end
end
