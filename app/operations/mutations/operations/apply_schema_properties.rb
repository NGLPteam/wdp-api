# frozen_string_literal: true

module Mutations
  module Operations
    class ApplySchemaProperties
      include MutationOperations::Base
      include MutationOperations::WithSchemaErrors
      include Mutations::Shared::AttachesPolymorphicEntity

      include WDPAPI::Deps[apply: "schemas.instances.apply"]

      def call(entity:, property_values:)
        authorize entity, :update?

        application = apply.call entity, property_values

        with_applied_schema_values! application do |applied_entity|
          attach_polymorphic_entity! applied_entity
        end
      end
    end
  end
end
