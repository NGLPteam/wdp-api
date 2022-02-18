# frozen_string_literal: true

module Schemas
  module Definitions
    # Fetch a version map for a specific {SchemaDefinition}.
    class FetchStatic
      include Dry::Monads[:result]

      # @param [SchemaDefinition, SchemaVersion] schema
      # @return [Dry::Monads::Result(Schemas::Static::Definitions::VersionMap)]
      # @return [Dry::Monads::Failure(:not_static, SchemaDefinition)]
      def call(schema)
        return call(schema.schema_definition) if schema.kind_of?(SchemaVersion)

        key = "#{schema.namespace}.#{schema.identifier}"

        versions = ::Schemas::Static["definitions.map"][key]
      rescue Dry::Container::Error
        Failure[:not_static, schema]
      else
        Success versions
      end
    end
  end
end
