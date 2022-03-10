# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    class RecordProcessor
      include Dry::Monads[:result, :do]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects.Resolve(:protocol)
      include Dry::Effects.Interrupt(:deleted_record)
      include Harvesting::WithLogger
      include MonadicPersistence

      prepend Harvesting::HushActiveRecord

      # @param [Object] raw_record
      # @return [Dry::Monads::Success(HarvestRecord)]
      def call(raw_record)
        if exists?(raw_record)
          handle_existing! raw_record
        else
          handle_deleted! raw_record
        end
      end

      private

      # @param [Object] raw_record
      def exists?(raw_record)
        !(skip?(raw_record) || deleted?(raw_record))
      end

      # @!group Hooks

      # @param [HarvestRecord] record
      # @param [Object] raw_record
      # @return [Dry::Monads::Result]
      def adjust_record!(record, raw_record)
        # :nocov:
        Success()
        # :nocov:
      end

      # @abstract
      # @param [Object] raw_record
      def deleted?(raw_record)
        # :nocov:
        raise NotImplementedError, "must implement"
        # :nocov:
      end

      # @abstract
      # @param [Object] raw_record
      def skip?(raw_record)
        # :nocov:
        false
        # :nocov:
      end

      # @abstract
      # @param [Object] raw_record
      # @return [Dry::Monads::Success(String)]
      def record_identifier_for(raw_record)
        protocol.record_identifier.(raw_record)
      end

      # @abstract
      # @param [Object] raw_record
      # @return [String]
      def extract_raw_source(raw_record)
        # :nocov:
        raise NotImplementedError, "must implement"
        # :nocov:
      end

      # @!endgroup

      # @!group Scoping

      # @param [Object] raw_record
      # @return [ActiveRecord::Relation<HarvestRecord>]
      def scope_for(raw_record)
        identifier = yield record_identifier_for raw_record

        harvest_records_by_identifier identifier
      end

      # @param [String] identifier
      # @return [ActiveRecord::Relation<HarvestRecord>]
      def harvest_records_by_identifier(identifier)
        Success harvest_attempt.harvest_records.by_identifier(identifier)
      end

      # @param [Object] raw_record
      # @return [HarvestRecord]
      def record_for(raw_record)
        scope_for(raw_record).fmap(&:first_or_initialize)
      end

      # @!endgroup

      # @!group Handlers

      # @param [Object] raw_record
      # @return [Dry::Monads::Success]
      def handle_existing!(raw_record)
        record = yield record_for raw_record

        identifier = yield record_identifier_for raw_record

        logger.log "Processing record #{identifier.inspect}"

        record.metadata_format = metadata_format.format

        yield extract_source! record, raw_record
        yield extract_metadata! record, raw_record
        yield adjust_record! record, raw_record

        monadic_save record
      end

      # @param [Object] raw_record
      # @return [void]
      def handle_deleted!(raw_record)
        identifier = yield record_identifier_for raw_record

        yield scope_for(raw_record).fmap(&:destroy_all)

        logger.log "Received deleted record identifier: #{identifier.inspect}"

        deleted_record
      end

      # @!endgroup

      # @!group Steps

      # @param [HarvestRecord] record
      # @param [Object] raw_record
      # @return [Dry::Monads::Result]
      def extract_source!(record, raw_record)
        record.raw_source = yield protocol.extract_raw_source.(raw_record)

        Success()
      end

      # @param [HarvestRecord] record
      # @param [Object] raw_record
      # @return [Dry::Monads::Result]
      def extract_metadata!(record, raw_record)
        raw_metadata = yield protocol.extract_raw_metadata.(raw_record)

        validated_raw_metadata = yield metadata_format.validate_raw_metadata.(raw_metadata)

        record.raw_metadata_source = validated_raw_metadata

        Success()
      end

      # @!endgroup
    end
  end
end
