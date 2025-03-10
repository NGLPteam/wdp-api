# frozen_string_literal: true

module Harvesting
  module Contributors
    class Upsert
      include Dry::Monads[:do, :result]
      include Dry::Effects.Reader(:harvest_source)
      include Dry::Effects.State(:extracted_contributor_ids)
      include MonadicPersistence
      include MeruAPI::Deps[
        connect_or_create: "harvesting.contributors.connect_or_create",
      ]

      # @param [Harvesting::Contributors::Proxy] proy
      # @return [Dry::Monads::Success(HarvestContributor)]
      def call(proxy)
        harvest_contributor = proxy.find_and_assign_for harvest_source

        harvest_contributor.save!

        extracted_contributor_ids << harvest_contributor.id

        yield connect_or_create.call harvest_contributor

        Success harvest_contributor
      end
    end
  end
end
