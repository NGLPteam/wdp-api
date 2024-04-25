# frozen_string_literal: true

module Schemas
  module Versions
    # Fetch the static version for a specific {SchemaVersion}.
    #
    # @see Schemas::Definitions::FetchStatic
    class FetchStatic
      include Dry::Monads[:result, :do]
      include MeruAPI::Deps[
        fetch_versions: "schemas.definitions.fetch_static"
      ]

      # @param [SchemaVersion] schema_version
      # @return [Dry::Monads::Success(Schemas::Static::Definitions::Version)]
      # @return [Dry::Monads::Failure(:not_static, SchemaDefinition)]
      # @return [Dry::Monads::Failure(:unknown_version, SchemaVersion)]
      def call(schema_version)
        versions = yield fetch_versions.call schema_version

        version = versions[schema_version.number.to_s]

        return Failure[:unknown_version, SchemaVersion] if version.blank?

        Success version
      end
    end
  end
end
