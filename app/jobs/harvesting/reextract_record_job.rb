# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::ReextractRecord
  class ReextractRecordJob < ApplicationJob
    queue_as :extraction

    unique :until_and_while_executing, lock_ttl: 30.minutes, on_conflict: :log, runtime_lock_ttl: 30.minutes, on_runtime_conflict: :log

    # @param [HarvestRecord] harvest_record
    # @return [void]
    def perform(harvest_record)
      call_operation! "harvesting.actions.reextract_record", harvest_record
    end
  end
end
