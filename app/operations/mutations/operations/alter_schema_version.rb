# frozen_string_literal: true

module Mutations
  module Operations
    class AlterSchemaVersion
      include MutationOperations::Base
      include MutationOperations::WithSchemaErrors
      include AssignsSchemaVersion
      include AttachesPolymorphicEntity

      include WDPAPI::Deps[alter: "schemas.instances.alter_version"]

      def call(entity:, property_values:, strategy: :apply, **)
        authorize entity, :update?

        schema_version = fetch_found_schema_version!

        alteration = alter.call(entity, schema_version, property_values, strategy: strategy)

        with_applied_schema_values! alteration do |applied_entity|
          attach_polymorphic_entity! applied_entity
        end
      end
    end
  end
end
