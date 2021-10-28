# frozen_string_literal: true

module Harvesting
  class PrepareEntitiesFromRecordJob < ApplicationJob
    queue_as :harvesting

    # @param [HarvestRecord] harvest_record
    # @return [void]
    def perform(harvest_record)
      call_operation! "harvesting.actions.prepare_entities_from_record", harvest_record
    end
  end
end
