# frozen_string_literal: true

module Harvesting
  module Records
    # @see Harvesting::Records::ExtractEntities
    class ExtractEntitiesJob < ApplicationJob
      queue_as :harvesting

      # @param [HarvestRecord] harvest_record
      # @return [void]
      def perform(harvest_record)
        call_operation! "harvesting.records.extract_entities", harvest_record

        Harvesting::Records::UpsertEntitiesJob.perform_later harvest_record
      end
    end
  end
end
