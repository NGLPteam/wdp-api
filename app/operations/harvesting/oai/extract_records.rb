# frozen_string_literal: true

module Harvesting
  module OAI
    # Extract records from an OAI-PMH feed.
    class ExtractRecords
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:harvest_set)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_mapping)
      include Dry::Effects.Resolve(:metadata_format)
      include Harvesting::OAI::WithClient
      include Harvesting::WithLogger
      include WDPAPI::Deps[process_record: "harvesting.oai.process_record"]

      SANITY_MAX = 5000

      # @param [HarvestAttempt] harvest_attempt
      def call(harvest_attempt)
        yield paginate_requests!

        Success nil
      rescue ::OAI::Exception => e
        if e.code == "noRecordsMatch"
          logger.log "No records to extract"

          return Success(nil)
        end

        Failure[:invalid_request, e.message, e]
      end

      private

      # @return [void]
      def paginate_requests!
        options = yield prepare_initial_request

        resp = oai_client.list_records options

        total = 0

        loop do
          progress resp

          break if resp.count == 0

          records = resp.map do |oai_record|
            yield process_record.call oai_record
          end.compact

          total += records.size

          break if resp.resumption_token.blank? || total >= SANITY_MAX

          resp = oai_client.list_records resumption_token: resp.resumption_token
        end

        Success nil
      end

      def prepare_initial_request
        options = {}.tap do |h|
          h[:metadata_prefix] = metadata_format.oai_metadata_prefix

          h[:set] = harvest_set.identifier if harvest_set.present?
        end

        Success options
      end

      def progress(resp)
        count = resp.count

        el = resumption_token_for resp

        if count == 0
          logger.log "No records to extract"
        elsif el.present?
          list_size = el["completeListSize"]&.to_i

          cursor = el["cursor"]&.to_i

          update_record_count! list_size if cursor == 0

          logger.log "Extracting #{count} of #{list_size} record(s), cursor: #{cursor}"
        else
          update_record_count! count

          logger.log "Extracting #{count} record(s), no cursor"
        end
      end

      def resumption_token_for(resp)
        resp.xpath_first(resp.doc, "/OAI-PMH/ListRecords/resumptionToken")
      end

      def total_records_for(resp)
        token = resumption_token_for resp

        token.present? ? token["completeListSize"]&.to_i || resp.count : resp.count
      end

      def update_record_count!(total)
        harvest_attempt.update_column :record_count, total
      end
    end
  end
end
