# frozen_string_literal: true

module Schemas
  module Static
    class LoadVersion
      include Dry::Monads[:do, :result]
      include MonadicPersistence
      include WDPAPI::Deps[validate_metaschema: "schemas.validate_metaschema"]

      # @param [SchemaDefinition] definition
      # @param [Schemas::Static::Definitions::Version] static_version
      # @return [SchemaVersion]
      def call(definition, static_version)
        configuration = yield validate static_version

        version = yield lookup definition, static_version.number

        version.configuration = configuration

        monadic_save version
      end

      private

      # @param [Schemas::Static::Definitions::Version] static_version
      # @return [Dry::Monads::Result]
      def validate(static_version)
        configuration = static_version.raw_data

        validate_metaschema.call "entity-definition", configuration
      end

      # @param [SchemaDefinition] definition
      # @param [String] number
      # @return [Dry::Monads::Result()]
      def lookup(definition, number)
        version = SchemaVersion.lookup_or_initialize number, schema_definition: definition

        Success version
      end
    end
  end
end
