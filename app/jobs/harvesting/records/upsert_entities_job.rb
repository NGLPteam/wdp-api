# frozen_string_literal: true

module Harvesting
  module Records
    # @see Harvesting::Records::UpsertEntities
    class UpsertEntitiesJob < ApplicationJob
      queue_as :harvesting

      max_runtime 30.minutes

      # @param [HarvestRecord] harvest_record
      # @return [void]
      def perform(harvest_record)
        call_operation! "harvesting.records.upsert_entities", harvest_record
      end
    end
  end
end
