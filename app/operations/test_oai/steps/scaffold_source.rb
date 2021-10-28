# frozen_string_literal: true

module TestOAI
  module Steps
    class ScaffoldSource
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      def call(name:, base_url:, protocol: "oai", metadata_format: "mods")
        source = HarvestSource.where(name: name).first_or_initialize do |hs|
          hs.protocol = protocol
          hs.metadata_format = metadata_format
          hs.base_url = base_url
        end

        monadic_save source
      end
    end
  end
end
