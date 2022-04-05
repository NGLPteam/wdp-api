# frozen_string_literal: true

module Harvesting
  module Sources
    class Upsert
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      # @return [Dry::Monads::Success(HarvestSource)]
      def call(name, base_url, protocol: "oai", metadata_format: "mods")
        source = HarvestSource.where(name: name).first_or_initialize

        source.base_url = base_url
        source.protocol = protocol
        source.metadata_format = metadata_format

        monadic_save source
      end
    end
  end
end
