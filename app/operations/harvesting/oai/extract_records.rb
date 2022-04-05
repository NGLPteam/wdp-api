# frozen_string_literal: true

module Harvesting
  module OAI
    # Extract records from an OAI-PMH feed.
    class ExtractRecords < Harvesting::Protocols::RecordBatchExtractor
      include Dry::Monads[:result, :do]
      include Harvesting::OAI::WithClient
      include WDPAPI::Deps[
        process_record: "harvesting.oai.process_record"
      ]

      private

      # @param [String, nil] cursor
      # @return [::OAI::ListRecordsResponse]
      def build_batch(cursor: nil)
        if cursor.present?
          oai_client.list_records resumption_token: cursor
        else
          options = options_for_initial_request

          oai_client.list_records options
        end
      rescue ::OAI::Exception => e
        no_records if e.code == "noRecordsMatch"

        raise e
      end

      # @param [::OAI::ListRecordsResponse] batch
      # @return [String, nil]
      def next_cursor_from(batch)
        batch.resumption_token
      end

      # @param [::OAI::ListRecordsResponse] batch
      # @return [void]
      def on_initial_batch(batch)
        total_count = total_record_count_for batch

        update_total_record_count! total_count
      end

      # @param [::OAI::ListRecordsResponse] batch
      # @return [void]
      def on_batch(batch)
        token = resumption_token_for batch

        count = batch.count

        total = harvest_attempt.record_count.to_i.nonzero? || "unknown"

        message = "Extracting #{count}/#{total} record(s)"

        if token.present?
          cursor = token["cursor"]&.to_i

          logger.log "#{message}, cursor: #{cursor}"
        else
          logger.log "#{message}, no cursor"
        end
      end

      def options_for_initial_request
        {}.tap do |h|
          h[:metadata_prefix] = metadata_format.oai_metadata_prefix

          h[:set] = harvest_set.identifier if harvest_set.present?
        end
      end

      # @param [::OAI::ListRecordsResponse] batch
      # @return [REXML::Element]
      def resumption_token_for(batch)
        batch.xpath_first(batch.doc, "/OAI-PMH/ListRecords/resumptionToken")
      end

      # @param [::OAI::ListRecordsResponse] batch
      # @return [Integer, nil]
      def total_record_count_for(batch)
        token = resumption_token_for batch

        return nil if token.blank?

        token["completeListSize"]&.to_i
      end
    end
  end
end
