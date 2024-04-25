# frozen_string_literal: true

module Harvesting
  module Contributions
    class Upsert
      include Dry::Monads[:result]
      include Dry::Effects.State(:extracted_contribution_ids)

      # @return [Dry::Monads::Success(HarvestContribution)]
      def call(harvest_entity, harvest_contributor, kind: nil, metadata: {})
        attrs = {
          harvest_entity_id: harvest_entity.id,
          harvest_contributor_id: harvest_contributor.id,
          kind:,
          metadata:,
        }

        contribution_upsertion = HarvestContribution.upsert attrs, unique_by: %i[harvest_contributor_id harvest_entity_id], returning: %i[id]

        contribution_id = contribution_upsertion.pick("id")

        extracted_contribution_ids << contribution_id

        Success HarvestContribution.find contribution_id
      end
    end
  end
end
