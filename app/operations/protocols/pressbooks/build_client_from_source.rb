# frozen_string_literal: true

module Protocols
  module Pressbooks
    # Build a Pressbooks client,
    # based on data provided by a {HarvestSource}.
    class BuildClientFromSource
      include MeruAPI::Deps[
        build_client: "protocols.pressbooks.build_client",
      ]

      # @param [HarvestSource] harvest_source
      # @return [Dry::Monads::Success(::OAI::Client)]
      def call(harvest_source)
        build_client.(harvest_source.base_url, allow_insecure: harvest_source.allow_insecure)
      end
    end
  end
end
