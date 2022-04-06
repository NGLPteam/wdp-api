# frozen_string_literal: true

module Harvesting
  module Records
    # Prune {HarvestContributor harvested contributors} during {HarvestRecord record} extraction.
    #
    # @api private
    # @see Harvesting::Records::PrepareEntities
    class PruneContributors
      include Dry::Effects::Handler.State(:extracted_contributor_ids)

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def call(harvest_record)
        existing_ids = harvest_record.harvest_contributor_ids

        ids, result = with_extracted_contributor_ids([]) do
          yield
        end

        orphaned_ids = existing_ids - ids

        HarvestContributor.sans_contributions.where(id: orphaned_ids).destroy_all

        return result
      end
    end
  end
end
