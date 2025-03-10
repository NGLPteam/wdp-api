# frozen_string_literal: true

module Harvesting
  module Sources
    class Upsert
      include MonadicPersistence

      # @return [Dry::Monads::Success(HarvestSource)]
      def call(identifier, name, base_url, protocol:, metadata_format:, **options)
        source = HarvestSource.to_upsert_by_identifier(identifier)

        source.name = name
        source.base_url = base_url
        source.protocol = protocol
        source.metadata_format = metadata_format

        source.merge_harvesting_options!(**options)

        monadic_save source
      end
    end
  end
end
