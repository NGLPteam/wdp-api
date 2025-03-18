# frozen_string_literal: true

module Harvesting
  module Schedules
    # @see Harvesting::Schedules::Parser
    class Parse < Support::SimpleServiceOperation
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      service_klass Harvesting::Schedules::Parser
    end
  end
end
