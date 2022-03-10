# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert a set of {HarvestEntity staged entities} from a {HarvestRecord}.
    class UpsertEntities < Harvesting::BaseAction
      include WDPAPI::Deps[
        prepare_entities: "harvesting.actions.prepare_entities_from_record",
        upsert_entity: "harvesting.entities.upsert",
      ]

      runner do
        param :harvest_record, Harvesting::Types::Record

        option :reprepare, Harvesting::Types::Bool, default: proc { false }

        logs_errors_from! :harvest_record
      end

      before_perform :clear_harvest_errors!

      first_argument_provides_middleware!

      defer_ordering_refresh!

      # @param [HarvestRecord] harvest_record
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def perform(harvest_record, reprepare: false)
        if reprepare
          yield prepare_entities.call(harvest_record)

          return Success() if harvest_record.harvest_errors.any?
        end

        harvest_record.harvest_entities.roots.find_each do |root_entity|
          upsert_entity.call(root_entity).or do |reason|
            harvest_record.log_harvest_error!(*root_entity.to_failed_upsert(reason))
          end
        end

        return Success()
      end
    end
  end
end
