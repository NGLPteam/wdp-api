# frozen_string_literal: true

module Harvesting
  module Contributions
    class Upsert
      include Dry::Monads[:result]
      include Dry::Effects.State(:extracted_contribution_ids)

      # @param [HarvestEntity] harvest_entity
      # @param [HarvestContributor] harvest_contributor
      # @param [Harvesting::Contributions::Proxy] contribution_proxy
      # @return [Dry::Monads::Success(HarvestContribution)]
      def call(harvest_entity, harvest_contributor, contribution_proxy)
        contribution_proxy => { role:, inner_position:, metadata:, outer_position:, }

        attrs = {
          harvest_entity_id: harvest_entity.id,
          harvest_contributor_id: harvest_contributor.id,
          role_id: role.try(:id),
          inner_position:,
          outer_position:,
          metadata:,
        }

        unique_by = role.present? ? "harvest_contributions_with_role_uniqueness" : "harvest_contributions_sans_role_uniqueness"

        contribution_upsertion = HarvestContribution.upsert attrs, unique_by:, returning: %i[id]

        contribution_id = contribution_upsertion.pick("id")

        extracted_contribution_ids << contribution_id

        Success HarvestContribution.find contribution_id
      end
    end
  end
end
