# frozen_string_literal: true

module PilotHarvesting
  class SeedJob < ApplicationJob
    queue_as :maintenance

    # @param [#to_s] name
    # @return [void]
    def perform(name)
      call_operation! "pilot_harvesting.seed", name
    end
  end
end
