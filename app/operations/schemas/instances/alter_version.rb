# frozen_string_literal: true

module Schemas
  module Instances
    # Alter a {SchemaVersion} for a {HasSchemaDefinition schema instance},
    # applying new properties if provided.
    #
    # @see Schemas::Instances::Apply
    class AlterVersion
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[apply: "schemas.instances.apply"]
      include MonadicPersistence

      prepend TransactionalCall

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion] schema_version
      # @param [Hash] new_values
      # @return [Dry::Monads::Result]
      def call(schema_instance, schema_version, new_values)
        entity = yield alter_version! schema_instance, schema_version

        apply.call entity, new_values
      end

      private

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion] schema_version
      def alter_version!(schema_instance, schema_version)
        schema_instance.schema_version = schema_version

        monadic_save schema_instance
      end
    end
  end
end
