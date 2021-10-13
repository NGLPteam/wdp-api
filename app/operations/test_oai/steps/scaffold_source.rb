# frozen_string_literal: true

module TestOAI
  module Steps
    class ScaffoldSource
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      def call
        source = HarvestSource.where(name: "Cornell DSpace").first_or_initialize do |hs|
          hs.kind = "oai"
          hs.source_format = "mods"
          hs.base_url = "https://ecommons.cornell.edu/oai/request"
        end

        monadic_save source
      end
    end
  end
end
