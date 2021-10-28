# frozen_string_literal: true

module Harvesting
  module OAI
    # Extract sets from an OAI-PMH feed.
    class ExtractSets
      include Dry::Monads[:do, :result]
      include Harvesting::OAI::WithClient
      include Harvesting::WithLogger

      # @param [HarvestSource] harvest_source
      def call(harvest_source)
        resp = oai_client.list_sets

        return Success(nil) if resp.count == 0

        loop do
          progress resp

          records = resp.map do |set|
            yield prepare harvest_source, set
          end.compact.uniq { |rec| rec[:identifier] }

          yield upsert! records if records.any?

          break if resp.resumption_token.blank?

          resp = oai_client.list_sets resumption_token: resp.resumption_token
        end

        Success nil
      end

      private

      def progress(resp)
        el = resp.xpath_first(resp.doc, "/OAI-PMH/ListSets/resumptionToken")

        return if el.blank?

        list_size = el["completeListSize"]&.to_i

        cursor = el["cursor"]&.to_i

        count = resp.count

        return if list_size.blank? || cursor.blank? || count.blank?

        logger.log "Extracting #{count} of #{list_size} set(s), cursor: #{cursor}"
      end

      # @param [HarvestSource] harvest_source
      # @param [OAI::Set] set
      # @return [void]
      def prepare(harvest_source, set)
        return Success(nil) if set.spec.blank?

        attributes = {
          harvest_source_id: harvest_source.id,
          identifier: set.spec,
          name: set.name.presence || set.spec,
          description: set.description&.text.presence,
        }.compact

        Success attributes
      end

      def upsert!(records)
        HarvestSet.upsert_all records, unique_by: %i[harvest_source_id identifier]

        Success nil
      end
    end
  end
end
