# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # @api private
      class UpsertContribution
        include Dry::Monads[:do, :result]
        include WDPAPI::Deps[
          upsert_contributor: "harvesting.contributors.upsert",
        ]

        # @param [HarvestEntity] harvest_entity
        # @param [{ Symbol => Object }] contributor
        # @param [String, nil] kind
        # @param [Hash] metadata
        # @return [Dry::Monads::Result(void)]
        def call(harvest_entity, contributor:, kind: nil, metadata: {})
          harvest_contributor = yield upsert_contributor.call(contributor[:kind], contributor[:attributes], contributor[:properties])

          attrs = {
            harvest_entity_id: harvest_entity.id,
            harvest_contributor_id: harvest_contributor.id,
            kind: kind,
            metadata: metadata,
          }

          HarvestContribution.upsert attrs, unique_by: %i[harvest_contributor_id harvest_entity_id]

          Success nil
        end
      end
    end
  end
end
