# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    #
    # This will ideally be able to be refactored into something supported by JobIteration.
    class RecordBatchExtractor
      include Dry::Monads[:result]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_mapping)
      include Dry::Effects.Resolve(:harvest_set)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects.Resolve(:protocol)
      include Dry::Effects.Resolve(:record_extraction_progress)
      include Dry::Effects::Handler.Interrupt(:halt_enumeration, as: :catch_halt_enumeration)
      include Dry::Effects.Interrupt(:halt_enumeration)
      include Dry::Effects.Interrupt(:no_records)
      include Harvesting::WithLogger

      # rubocop:disable Style/Alias
      alias_method :progress, :record_extraction_progress
      # rubocop:enable Style/Alias

      def call(*)
        progress.reset!

        wrap_batch_enumeration do
          enumerate!
        end

        Success()
      end

      private

      def enumerate!
        batch = build_batch(cursor: nil)

        on_initial_batch batch

        halt_enumeration if batch.nil?

        prev_cursor = nil

        loop do
          pre_process! batch

          processed = process_batch batch

          post_process! processed

          next_cursor = next_cursor_from batch

          halt_enumeration if next_cursor.blank?

          if prev_cursor.present? && prev_cursor == next_cursor
            logger.log("cursor repeating infinitely: #{prev_cursor}")

            halt_enumeration
          end

          logger.log("next cursor: #{next_cursor.inspect}")

          batch = build_batch cursor: next_cursor

          prev_cursor = next_cursor
        end
      end

      # @abstract
      # @param [Object] batch
      # @return [Integer]
      def batch_count_for(batch)
        batch.try(:count).to_i
      end

      # @abstract
      # @param [Object] batch
      # @return [Dry::Monads::Success(Object)]
      # @return [Dry::Monads::Failure]
      def next_cursor_from(batch)
        # :nocov:
        raise NoMethodError, "must implement"
        # :nocov:
      end

      # @abstract
      # @param [Object] cursor
      # @return [Object, nil]
      def build_batch(cursor: nil)
        # :nocov:
        raise NoMethodError, "must implement"
        # :nocov:
      end

      # @abstract
      # @param [Object] batch
      # @return [void]
      def on_initial_batch(batch); end

      # @abstract
      # @param [Object] batch
      # @return [void]
      def on_batch(batch); end

      # @param [Object]
      # @return [<HarvestRecord>]
      def process_batch(batch)
        protocol.process_record_batch.(batch).value!
      end

      # @param [Object] batch
      # @return [void]
      def pre_process!(batch)
        progress.batches!

        record_count = batch_count_for batch

        no_records if record_count == 0

        progress.records! record_count

        on_batch batch
      end

      # @param [<HarvestRecord>] processed
      # @return [void]
      def post_process!(processed)
        logger.log "Batch complete"

        progress.processed! processed.size

        halt_enumeration if progress.should_stop?
      end

      # @param [Integer] total
      # @return [void]
      def update_total_record_count!(total)
        return if total.blank?

        return if total == harvest_attempt.record_count

        harvest_attempt.update_column :record_count, total
      end

      # @return [void]
      def wrap_batch_enumeration
        with_halted_enumeration do
          yield
        end
      end

      # @return [void]
      def with_halted_enumeration
        halted, _ = catch_halt_enumeration do
          yield if block_given?
        end

        logger.log("Enumeration halted") if halted
      end
    end
  end
end
