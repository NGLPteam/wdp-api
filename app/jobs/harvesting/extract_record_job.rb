# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::ExtractRecord
  class ExtractRecordJob < ApplicationJob
    queue_as :extraction

    unique_job! by: :all_args

    discard_on Harvesting::Records::Unknown
    discard_on Harvesting::Sources::Unknown

    # @param [String] source_identifier
    # @param [String] record_identifier
    # @return [void]
    def perform(source_identifier, record_identifier)
      call_operation! "harvesting.actions.extract_record", source_identifier, record_identifier
    end
  end
end
