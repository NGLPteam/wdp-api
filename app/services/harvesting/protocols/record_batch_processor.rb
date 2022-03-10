# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    # @see Harvesting::Protocols::RecordProcessor#call
    class RecordBatchProcessor
      include Dry::Monads[:result]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_mapping)
      include Dry::Effects.Resolve(:harvest_set)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects.Resolve(:protocol)
      include Dry::Effects::Handler.Interrupt(:deleted_record, as: :catch_deleted)
      include Harvesting::WithLogger

      # @param [Object] batch
      # @return [Dry::Monads::Success<HarvestRecord>]
      def call(batch)
        records = []

        enumerate_over batch do |raw_record|
          process!(raw_record).fmap do |harvest_record|
            records << harvest_record if harvest_record.present?
          end
        end

        Success records
      end

      private

      # @!group Hooks

      # @param [Enumerable] batch
      # @return [void]
      def enumerate_over(batch)
        batch.to_enum.each do |raw_record|
          yield raw_record
        end
      end

      # @abstract
      # @param [Object] raw_record
      # @return [Dry::Monads::Success]
      def process(raw_record)
        # :nocov:
        protocol.process_record.(raw_record)
        # :nocov:
      end

      # @!endgroup

      # @param [Object] raw_record
      # @return [Dry::Monads::Result]
      def process!(raw_record)
        with_deleted do
          process raw_record
        end
      end

      def with_deleted
        deleted, result = catch_deleted do
          yield
        end

        deleted ? Success(nil) : result
      end
    end
  end
end
