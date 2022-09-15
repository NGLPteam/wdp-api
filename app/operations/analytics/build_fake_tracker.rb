# frozen_string_literal: true

module Analytics
  # @see Analytics::FakeTrackerBuilder
  class BuildFakeTracker
    # @return [Ahoy::Tracker]
    def call(**options)
      Analytics::FakeTrackerBuilder.new(**options).call
    end
  end
end
