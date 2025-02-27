# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::ApplySchemaProperties
    # @see Schemas::Instances::Apply
    class ApplySchemaProperties
      include MutationOperations::Base
      include Mutations::Shared::ForceRendersLayouts
      include Mutations::Shared::RefreshesOrderingsAsynchronously
      include Mutations::Shared::WithSchemaErrors

      include MeruAPI::Deps[apply: "schemas.instances.apply"]

      authorizes! :entity, with: :update?

      def call(entity:, property_values:)
        apply_schema_properties! entity, property_values

        force_render_layouts_for! entity
      end
    end
  end
end
