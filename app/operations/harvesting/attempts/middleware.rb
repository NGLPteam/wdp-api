# frozen_string_literal: true

module Harvesting
  module Attempts
    # Prepares the state for a Dry::Effects handler
    class Middleware
      include Dry::Effects::Handler.Resolve
      include WDPAPI::Deps[
        build_oai_client: "harvesting.oai.build_client",
        build_metadata: "harvesting.metadata.build_processor",
      ]

      include Dry::Monads::Do.for(:build_handler_state_for)

      # @param [HarvestSource] harvest_source
      # @return [void]
      def call(harvest_attempt)
        handler_state = build_handler_state_for harvest_attempt

        provide handler_state do
          yield if block_given?
        end
      end

      def build_handler_state_for(harvest_attempt)
        harvest_source = harvest_attempt.harvest_source

        state = {
          collection: harvest_attempt.collection,
          harvest_source: harvest_source,
          harvest_attempt: harvest_attempt,
          harvest_set: harvest_attempt.harvest_set,
          harvest_mapping: harvest_attempt.harvest_mapping,
          logger: harvest_attempt.logger,
        }

        state[:metadata_processor] = yield build_metadata.call(harvest_source)

        if harvest_source.kind == "oai"
          client = yield build_oai_client.call harvest_source

          state[:oai_client] = client
        end

        return state
      end
    end
  end
end
