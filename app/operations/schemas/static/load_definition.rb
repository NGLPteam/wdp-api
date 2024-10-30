# frozen_string_literal: true

module Schemas
  module Static
    class LoadDefinition
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      include MeruAPI::Deps[
        load_version: "schemas.static.load_version",
        reorder_versions: "schemas.versions.reorder"
      ]

      # @param [StaticSchemaDefinition] static_definition
      # @return [SchemaDefinition]
      def call(static_definition)
        definition = yield find_or_create_definition static_definition

        static_definition.versions.each do |version|
          yield load_version.call(definition, version)
        end

        yield reorder_versions.call definition

        Success definition
      end

      private

      # @param [StaticSchemaDefinition] static_definition
      # @return [Dry::Monads::Success(SchemaDefinition)]
      def find_or_create_definition(static_definition)
        static_definition => { namespace:, identifier:, kind:, name:, }

        definition = SchemaDefinition.lookup_or_initialize namespace, identifier

        definition.assign_attributes(kind:, name:)

        # This should never fail at runtime.
        definition.save!

        Success definition
      end
    end
  end
end
