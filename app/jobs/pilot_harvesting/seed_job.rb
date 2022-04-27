# frozen_string_literal: true

module PilotHarvesting
  class SeedJob < ApplicationJob
    queue_as :maintenance

    unique :until_and_while_executing, lock_ttl: 1.hour, on_conflict: :log

    # @param [#to_s] name
    # @return [void]
    def perform(name)
      call_operation! "pilot_harvesting.seed", name
    end
  end
end
