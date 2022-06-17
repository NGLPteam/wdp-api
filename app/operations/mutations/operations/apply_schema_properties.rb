# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::ApplySchemaProperties
    # @see Schemas::Instances::Apply
    class ApplySchemaProperties
      include MutationOperations::Base
      include Mutations::Shared::RefreshesOrderingsAsynchronously
      include Mutations::Shared::WithSchemaErrors

      include WDPAPI::Deps[apply: "schemas.instances.apply"]

      def call(entity:, property_values:)
        authorize entity, :update?

        apply_schema_properties! entity, property_values
      end
    end
  end
end
