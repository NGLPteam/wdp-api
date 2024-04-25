# frozen_string_literal: true

module Harvesting
  module OAI
    class AugmentMiddleware < Harvesting::Protocols::Actions::AugmentMiddleware
      include MeruAPI::Deps[
        build_client: "harvesting.oai.build_client",
      ]

      # @param [Hash] state
      # @option state [HarvestSource] :harvest_source
      # @return [Dry::Monads::Result]
      def call(state)
        harvest_source = state[:harvest_source]

        if harvest_source.present?
          state[:oai_client] = yield build_client.call harvest_source

          Success state
        else
          Failure[:missing_harvest_source, "Cannot augment middleware for OAI-PMH without harvest source"]
        end
      end
    end
  end
end
