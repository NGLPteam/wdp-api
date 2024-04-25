# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # @api private
      class UpsertContribution
        include Dry::Monads[:do, :result]
        include MeruAPI::Deps[
          upsert_contributor: "harvesting.contributors.upsert",
          upsert_contribution: "harvesting.contributions.upsert",
        ]

        # @param [HarvestEntity] harvest_entity
        # @param [{ Symbol => Object }] contributor
        # @param [String, nil] kind
        # @param [Hash] metadata
        # @return [Dry::Monads::Success(HarvestContribution)]
        def call(harvest_entity, contributor:, kind: nil, metadata: {})
          harvest_contributor = yield upsert_contributor.call(contributor[:kind], contributor[:attributes], contributor[:properties])

          upsert_contribution.(harvest_entity, harvest_contributor, kind:, metadata:)
        end
      end
    end
  end
end
