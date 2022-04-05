# frozen_string_literal: true

module TestOAI
  module Steps
    class ScaffoldSource
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include WDPAPI::Deps[upsert: "harvesting.sources.upsert"]

      def call(identifier:, name:, base_url:, protocol: "oai", metadata_format: "mods")
        upsert.(identifier, name, base_url, protocol: protocol, metadata_format: metadata_format)
      end
    end
  end
end
