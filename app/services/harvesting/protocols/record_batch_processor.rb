# frozen_string_literal: true

module Harvesting
  module Protocols
    # Given a "batch" of records (a single page as part of pagination, etc),
    # process each record and return the resulting {HarvestRecord}s.
    #
    # @see Harvesting::Protocols::RecordProcessor#call
    class RecordBatchProcessor
      include Dry::Monads[:result]
      include Dry::Effects::Handler.Interrupt(:deleted_record, as: :catch_deleted)

      include Dry::Initializer[undefined: false].define -> do
        param :protocol, Harvesting::Types.Instance(::Harvesting::Protocols::Context)
      end

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
      # @return [Dry::Monads::Success(HarvestRecord)]
      def process(raw_record)
        protocol.process_record.(raw_record)
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
