# frozen_string_literal: true

module PilotHarvesting
  # @see PilotHarvesting::Seed
  class SeedJob < ApplicationJob
    queue_as :harvesting

    unique_job! by: :first_arg

    # @param [#to_s] name
    # @return [void]
    def perform(name)
      call_operation! "pilot_harvesting.seed", name
    end
  end
end
