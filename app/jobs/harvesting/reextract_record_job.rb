# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::ReextractRecord
  class ReextractRecordJob < ApplicationJob
    queue_as :extraction

    unique_job! by: :first_arg

    # @param [HarvestRecord] harvest_record
    # @return [void]
    def perform(harvest_record)
      call_operation! "harvesting.actions.reextract_record", harvest_record
    end
  end
end
