# frozen_string_literal: true

module Mutations
  module Operations
    class AlterSchemaVersion
      include MutationOperations::Base
      include Mutations::Shared::WithSchemaErrors
      include Mutations::Shared::AssignsSchemaVersion
      include Mutations::Shared::AttachesPolymorphicEntity
      include WDPAPI::Deps[alter: "schemas.instances.alter_version"]

      use_contract! :alter_schema_version

      def call(entity:, property_values:, strategy: :apply, **)
        authorize entity, :update?

        alteration = alter.call(entity, loaded_schema_version, property_values, strategy: strategy)

        with_applied_schema_values! alteration do |applied_entity|
          attach_polymorphic_entity! applied_entity
        end
      end
    end
  end
end
