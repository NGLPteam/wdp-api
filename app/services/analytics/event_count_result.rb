# frozen_string_literal: true

module Analytics
  # @see Types::AnalyticsEventCountResultType
  class EventCountResult < Shared::FlexibleStruct
    attribute :date, Analytics::Types::Date
    attribute? :time, Analytics::Types::Time.optional
    attribute :count, Analytics::Types::Integer.default(0)
  end
end
