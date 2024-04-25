# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::UpsertEntities
  class UpsertEntitiesForRecordJob < ApplicationJob
    queue_as :harvesting

    unique_job! by: :first_arg

    # @param [HarvestRecord] harvest_record
    # @param [Boolean] reprepare
    # @return [void]
    def perform(harvest_record, reprepare: false)
      call_operation! "harvesting.actions.upsert_entities", harvest_record, reprepare:
    end
  end
end
