# frozen_string_literal: true

module Harvesting
  module Protocols
    module OAI
      # Transform a single `OAI::Record` from an OAI-PMH feed
      # into a {HarvestRecord} for later consumption.
      class RecordProcessor < Harvesting::Protocols::RecordProcessor
        # @param [HarvestRecord] record
        # @param [OAI::Record] oai_record
        # @return [void]
        def adjust_record!(record, oai_record)
          record.source_changed_at = oai_record.header.datestamp

          record.local_metadata ||= {}

          record.local_metadata["datestamp"] = oai_record.header.datestamp

          Success()
        end
      end
    end
  end
end
