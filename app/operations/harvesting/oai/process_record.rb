# frozen_string_literal: true

module Harvesting
  module OAI
    # Transform a single `OAI::Record` from an OAI-PMH feed
    # into a {HarvestRecord} for later consumption.
    class ProcessRecord
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects.Resolve(:protocol)
      include Harvesting::WithLogger
      include MonadicPersistence

      # @param [OAI::Record] oai_record
      # @return [HarvestRecord, nil]
      def call(oai_record)
        unless oai_record.header.status == "deleted" || oai_record.metadata.blank?
          create_record_from oai_record
        else
          handle_deleted! oai_record
        end
      end

      private

      # @param [OAI::Record] oai_record
      # @return [HarvestRecord]
      def create_record_from(oai_record)
        record = record_for oai_record

        record.metadata_format = metadata_format.format

        yield extract_source_and_metadata! record, oai_record

        record.local_metadata = {
          datestamp: oai_record.header.datestamp,
        }

        monadic_save record
      end

      # @param [OAI::Record] oai_record
      # @return [ActiveRecord::Relation<HarvestRecord>]
      def scope_for(oai_record)
        identifier = oai_record.header.identifier

        harvest_attempt.harvest_records.by_identifier(identifier)
      end

      # @param [OAI::Record] oai_record
      # @return [HarvestRecord]
      def record_for(oai_record)
        scope_for(oai_record).first_or_initialize
      end

      # @param [HarvestRecord] record
      # @param [OAI::Record] oai_record
      # @return [void]
      def extract_source_and_metadata!(record, oai_record)
        record.raw_source = oai_record._source.to_s

        raw_metadata = yield protocol.extract_raw_metadata.call oai_record

        validated_raw_metadata = yield metadata_format.validate_raw_metadata.call raw_metadata

        record.raw_metadata_source = validated_raw_metadata

        Success nil
      end

      # @param [OAI::Record] oai_record
      # @return [void]
      def handle_deleted!(oai_record)
        scope_for(oai_record).destroy_all

        Success nil
      end
    end
  end
end
