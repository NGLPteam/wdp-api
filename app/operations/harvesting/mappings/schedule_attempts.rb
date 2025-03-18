# frozen_string_literal: true

module Harvesting
  module Mappings
    # @see Harvesting::Mappings::AttemptsScheduler
    class ScheduleAttempts < Support::SimpleServiceOperation
      service_klass Harvesting::Mappings::AttemptsScheduler
    end
  end
end
