# frozen_string_literal: true

module Harvesting
  module OAI
    # Extract records from an OAI-PMH feed.
    class ProcessRecord
      include Dry::Monads[:do, :result]
      include Dry::Effects::Handler.Resolve
      include Dry::Effects.Resolve(:collection)
      include Dry::Effects.Resolve(:harvest_set)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_mapping)
      include Dry::Effects.Resolve(:metadata_processor)
      include Harvesting::WithLogger
      include MonadicPersistence

      # @param [OAI::Record] record
      # @return [HarvestRecord]
      def call(oai_record)
        record = yield create_record_from oai_record

        provide harvest_record: record do
          yield metadata_processor.extract_entities.call record.raw_metadata_source
        end

        Success record
      end

      private

      # @param [OAI::Record] oai_record
      # @return [HarvestRecord]
      def create_record_from(oai_record)
        identifier = oai_record.header.identifier

        record = harvest_attempt.harvest_records.where(identifier: identifier).reorder(nil).first_or_initialize

        record.metadata_format = metadata_processor.format

        record.raw_source = oai_record._source.to_s

        record.raw_metadata_source = yield extract_raw_metadata_from oai_record

        record.local_metadata = {
          datestamp: oai_record.header.datestamp,
        }

        monadic_save record
      end

      # @param [OAI::Record] oai_record
      # @return [String]
      def extract_raw_metadata_from(oai_record)
        metadata = oai_record.metadata

        if metadata.respond_to?(:children) && metadata.children.length == 1
          Success metadata.children.first.to_s
        else
          Failure[:invalid_metadata, "expected metadata to have only 1 child"]
        end
      end
    end
  end
end
