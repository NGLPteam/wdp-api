# frozen_string_literal: true

module Harvesting
  module Protocols
    module OAI
      # Extract records from an OAI-PMH feed.
      class RecordBatchExtractor < Harvesting::Protocols::RecordBatchExtractor
        private

        # @param [String, nil] cursor
        # @return [::OAI::ListRecordsResponse]
        def build_batch(cursor: nil)
          if cursor.present?
            protocol.client.list_records resumption_token: cursor
          else
            options = options_for_initial_request

            protocol.client.list_records options
          end
        rescue ::OAI::Exception => e
          return no_records if e.code == "noRecordsMatch"

          logger.fatal("OAI-PMH Provider Error during record extraction: [#{e.code || "unknown"}] #{e.message}")

          halt_enumeration
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
          cursor = batch.resumption_token

          count = batch.count

          total = harvest_attempt.record_count.to_i.nonzero? || "unknown"

          message = "Extracting #{count}/#{total} record(s)"

          if cursor.present?
            logger.debug "#{message}, cursor: #{cursor}"
          else
            logger.debug "#{message}, no cursor"
          end
        end

        def options_for_initial_request
          {}.tap do |h|
            h[:metadata_prefix] = metadata_format.oai_metadata_prefix

            h[:set] = harvest_set.identifier if harvest_set.present?
          end
        end

        # @param [::OAI::ListRecordsResponse] batch
        # @return [Integer, nil]
        def total_record_count_for(batch)
          batch.complete_list_size
        end
      end
    end
  end
end
