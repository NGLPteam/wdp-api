# frozen_string_literal: true

module Schemas
  module Instances
    # A testing service
    #
    # @see Schemas::Instances::AlterAndGenerate
    # @see Schemas::Instances::Apply
    class AlterAndGenerate
      include Dry::Monads[:do, :result]
      include WDPAPI::Deps[
        apply_generated: "schemas.instances.apply_generated_properties",
        populate_orderings: "schemas.instances.populate_orderings"
      ]
      include MonadicPersistence

      prepend TransactionalCall

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion] schema_version
      # @return [Dry::Monads::Result]
      def call(schema_instance, schema_version)
        entity = yield alter_version! schema_instance, schema_version

        yield apply_generated.call entity

        yield populate_orderings.call entity

        Success entity
      end

      private

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion] schema_version
      def alter_version!(schema_instance, schema_version)
        schema_instance.schema_version = schema_version

        schema_instance.orderings.delete_all

        monadic_save schema_instance
      end
    end
  end
end
