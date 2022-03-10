# frozen_string_literal: true

module Harvesting
  module OAI
    # Transform a single `OAI::Record` from an OAI-PMH feed
    # into a {HarvestRecord} for later consumption.
    class ProcessRecord < Harvesting::Protocols::RecordProcessor
      # @param [HarvestRecord] record
      # @param [OAI::Record] oai_record
      # @return [void]
      def adjust_record!(record, oai_record)
        record.datestamp = oai_record.header.datestamp

        record.local_metadata = {
          datestamp: oai_record.header.datestamp,
        }

        Success()
      end

      # @param [OAI::Record] oai_record
      def deleted?(oai_record)
        oai_record.header.status == "deleted"
      end

      # @param [OAI::Record] oai_record
      def extract_raw_source(oai_record)
        oai_record._source.to_s
      end

      # @param [OAI::Record] oai_record
      def skip?(oai_record)
        oai_record.metadata.blank?
      end
    end
  end
end
