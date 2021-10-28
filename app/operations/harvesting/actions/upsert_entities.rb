# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert a set of {HarvestEntity staged entities} from a {HarvestRecord}.
    class UpsertEntities < Harvesting::BaseAction
      include WDPAPI::Deps[
        prepare_entities: "harvesting.actions.prepare_entities_from_record",
        upsert_entity: "harvesting.entities.upsert",
      ]

      prepend Harvesting::HushActiveRecord

      # @param [HarvestRecord] harvest_record
      # @param [Boolean] reprepare
      # @return [Dry::Monads::Result]
      def call(harvest_record, reprepare: false)
        wrap_middleware.call(harvest_record) do
          silence_activerecord do
            yield prepare_entities.call(harvest_record) if reprepare

            harvest_record.harvest_entities.roots.find_each do |root_entity|
              yield upsert_entity.call root_entity
            end
          end
        end

        Success nil
      end
    end
  end
end
