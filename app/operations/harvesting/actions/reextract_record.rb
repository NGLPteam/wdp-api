# frozen_string_literal: true

module Harvesting
  module Actions
    # Re-extract a {HarvestRecord}.
    #
    # @see Harvesting::Records::Reextract
    class ReextractRecord < Harvesting::BaseAction
      include WDPAPI::Deps[
        prepare_entities: "harvesting.records.prepare_entities",
        reextract: "harvesting.records.reextract",
        upsert_entities: "harvesting.records.upsert_entities",
      ]

      runner do
        param :harvest_record, Harvesting::Types::Record

        logs_errors_from! :harvest_record
      end

      before_perform :clear_harvest_errors!

      first_argument_provides_middleware!

      defer_ordering_refresh!

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def perform(harvest_record)
        yield reextract.(harvest_record)

        yield prepare_entities.(harvest_record)

        return Success() if harvest_record.harvest_entities.any?

        harvest_record.harvest_entities.roots.find_each do |root_entity|
          upsert_entity.call(root_entity).or do |reason|
            harvest_record.log_harvest_error!(*root_entity.to_failed_upsert(reason))
          end
        end
      end
    end
  end
end
