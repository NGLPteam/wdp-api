# frozen_string_literal: true

module Schemas
  module Instances
    # Alter a {SchemaVersion} for a {HasSchemaDefinition schema instance},
    # applying new properties if provided.
    #
    # @see Schemas::Instances::Apply
    class AlterVersion
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        apply: "schemas.instances.apply",
        find_version: "schemas.versions.find",
        populate_orderings: "schemas.instances.populate_orderings",
        sync_entity: "entities.sync",
      ]
      include MonadicPersistence

      prepend TransactionalCall

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion] schema_version
      # @param [Hash] new_values
      # @return [Dry::Monads::Result]
      def call(schema_instance, schema_version, new_values, strategy: :apply)
        entity = yield alter_version! schema_instance, schema_version

        yield apply.call entity, new_values unless strategy == :skip

        yield populate_orderings.call entity

        yield sync_entity.(entity)

        Success entity
      end

      private

      # @param [HasSchemaDefinition] schema_instance
      # @param [SchemaVersion] schema_version
      def alter_version!(schema_instance, schema_version)
        schema_instance.schema_version = yield find_version.call schema_version

        schema_instance.orderings.delete_all

        monadic_save schema_instance
      end
    end
  end
end
