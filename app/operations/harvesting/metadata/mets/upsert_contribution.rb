# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # @api private
      class UpsertContribution
        include Dry::Monads[:do, :result]
        include MeruAPI::Deps[
          upsert_contributor: "harvesting.contributors.upsert",
          upsert_contribution: "harvesting.contributions.upsert",
        ]

        # @param [HarvestEntity] harvest_entity
        # @param [Harvesting::Metadata::ValueExtraction::Struct] contribution
        # @return [Dry::Monads::Success(HarvestContribution)]
        def call(harvest_entity, contribution)
          harvest_contributor = yield upsert_contributor.call(
            contribution.contributor_kind,
            contribution.contributor_attributes,
            contribution.contributor_properties
          )

          upsert_contribution.(harvest_entity, harvest_contributor, kind: contribution.role, metadata: contribution.contribution_metadata)
        end
      end
    end
  end
end
