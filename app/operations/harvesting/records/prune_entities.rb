# frozen_string_literal: true

module Harvesting
  module Records
    # Prune {HarvestEntity harvested entities} during {HarvestRecord record} extraction.
    #
    # @api private
    # @see Harvesting::Records::PrepareEntities
    class PruneEntities
      include Dry::Effects::Handler.State(:extracted_entity_ids)

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def call(harvest_record)
        ids, result = with_extracted_entity_ids([]) do
          yield
        end

        harvest_record.harvest_entities.where.not(id: ids).destroy_all

        return result
      end
    end
  end
end
