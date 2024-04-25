# frozen_string_literal: true

module Schemas
  module Versions
    # Reload the static configuration for a specific {SchemaVersion}.
    class Reload
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        fetch_static: "schemas.versions.fetch_static",
        load_version: "schemas.static.load_version"
      ]

      # @param [SchemaVersion] schema_version
      # @note This does not return the same object in memory,
      #   as {Schemas::Static::LoadVersion} fetches a fresh
      #   {SchemaVersion}.
      # @return [Dry::Monads::Success(SchemaVersion)]
      def call(schema_version)
        static_version = yield fetch_static.call schema_version

        updated_version = yield load_version.call schema_version.schema_definition, static_version

        schema_version.reload

        Success updated_version
      end
    end
  end
end
