# frozen_string_literal: true

module Harvesting
  module Metadata
    # Upsert a list of {Harvesting::Contributions::Proxy contribution proxies} for a {HarvestEntity}.
    #
    # @api private
    # @see Harvesting::Metadata::UpsertContributionProxy
    class UpsertContributionProxies
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        upsert_proxy: "harvesting.metadata.upsert_contribution_proxy",
      ]

      # @param [HarvestEntity] harvest_entity
      # @param [<Harvesting::Contributions::Proxy>] proxies
      # @return [Dry::Monads::Success(HarvestContribution)]
      def call(harvest_entity, proxies)
        contributions = proxies.map do |proxy|
          yield upsert_proxy.(harvest_entity, proxy)
        end

        Success contributions.compact
      end
    end
  end
end
