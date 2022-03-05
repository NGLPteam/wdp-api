# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # @api private
      class UpsertContribution
        include Dry::Monads[:do, :result]
        include WDPAPI::Deps[
          upsert_contributor: "harvesting.contributors.upsert",
        ]

        # @param [HarvestEntity] harvest_entity
        # @param [Harvesting::Metadata::ValueExtraction::Struct] contribution
        # @param [String, nil] kind
        # @param [Hash] metadata
        # @return [Dry::Monads::Result(void)]
        def call(harvest_entity, contribution)
          harvest_contributor = yield upsert_contributor.call(
            contribution.contributor_kind,
            contribution.contributor_attributes,
            contribution.contributor_properties
          )

          attrs = {
            harvest_entity_id: harvest_entity.id,
            harvest_contributor_id: harvest_contributor.id,
            kind: contribution.role,
            metadata: contribution.contribution_metadata,
          }

          HarvestContribution.upsert attrs, unique_by: %i[harvest_contributor_id harvest_entity_id]

          Success nil
        end
      end
    end
  end
end
