# frozen_string_literal: true

module Harvesting
  module Sources
    # Prepares the state for a Dry::Effects handler
    class Middleware
      include Dry::Effects::Handler.Resolve
      include WDPAPI::Deps[
        build_oai_client: "harvesting.oai.build_client",
      ]

      include Dry::Monads::Do.for(:build_handler_state_for)

      # @param [HarvestSource] harvest_source
      # @return [void]
      def call(harvest_source)
        handler_state = build_handler_state_for harvest_source

        provide handler_state do
          yield if block_given?
        end
      end

      def build_handler_state_for(harvest_source)
        state = {
          harvest_source: harvest_source,
          logger: harvest_source.logger,
        }

        if harvest_source.kind == "oai"
          client = yield build_oai_client.call harvest_source

          state[:oai_client] = client
        end

        return state
      end
    end
  end
end
