# frozen_string_literal: true

module Protocols
  module OAI
    # Build an OAI client for talking to an OAI-PMH server,
    # based on data provided by a {HarvestSource}.
    class BuildClientFromSource
      include MeruAPI::Deps[
        build_client: "protocols.oai.build_client",
      ]

      # @param [HarvestSource] harvest_source
      # @return [Dry::Monads::Success(::OAI::Client)]
      def call(harvest_source)
        build_client.(harvest_source.base_url)
      end
    end
  end
end
