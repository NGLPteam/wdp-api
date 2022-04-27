# frozen_string_literal: true

module Harvesting
  module Records
    # @api private
    # @see Harvesting::Actions::PrepareEntitiesFromRecord
    #
    # Extract a set of {HarvestEntity staged entities} from a {HarvestRecord}, to be upserted later.
    class PrepareEntities
      include Dry::Monads[:result, :do]
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects::Handler.Interrupt(:skip_record, as: :catch_record_skip)
      include WDPAPI::Deps[
        handle_skip: "harvesting.records.skip",
        prune_extraction: "harvesting.records.prune_extraction",
        update_entity_count: "harvesting.records.update_entity_count",
      ]

      prepend Harvesting::HushActiveRecord

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def call(harvest_record)
        unless harvest_record.raw_metadata_source?
          yield handle_skip.(harvest_record, "No metadata", code: :no_metadata)

          return Success()
        end

        skipped, result = catch_record_skip do
          yield extract_and_prune_entities! harvest_record
        end

        if skipped
          handle_skip.(harvest_record, result)
        else
          harvest_record.clear_skip!

          Success result
        end
      rescue Dry::Struct::Error, Harvesting::Error => e
        harvest_record.log_harvest_error! :could_not_prepare_record, e.message, exception_klass: e.class.name, backtrace: e.backtrace

        handle_skip.(harvest_record, e.message, code: :extraction_exception)
      end

      private

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def extract_and_prune_entities!(harvest_record)
        prune_extraction.call(harvest_record) do
          yield metadata_format.extract_entities.(harvest_record.raw_metadata_source)
        end

        update_entity_count.(harvest_record)
      end
    end
  end
end
