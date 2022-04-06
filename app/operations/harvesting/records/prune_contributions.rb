# frozen_string_literal: true

module Harvesting
  module Records
    # Prune {HarvestContribution harvested contributions} during {HarvestRecord record} extraction.
    #
    # @api private
    # @see Harvesting::Records::PrepareEntities
    class PruneContributions
      include Dry::Effects::Handler.State(:extracted_contribution_ids)

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def call(harvest_record)
        ids, result = with_extracted_contribution_ids([]) do
          yield
        end

        HarvestContribution.by_record(harvest_record).where.not(id: ids).destroy_all

        return result
      end
    end
  end
end
