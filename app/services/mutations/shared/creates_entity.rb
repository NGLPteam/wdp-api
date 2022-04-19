# frozen_string_literal: true

module Mutations
  module Shared
    # Shared logic for creating a {Community}, {Collection}, or {Item}.
    #
    # @see Mutations::Shared::CreateEntityArguments
    module CreatesEntity
      extend ActiveSupport::Concern

      include Mutations::Shared::AssignsSchemaVersion
      include Mutations::Shared::AttachesPolymorphicEntity
      include Mutations::Shared::WithSchemaErrors

      SafeHash = Dry::Types["hash"].fallback { {} }

      included do
        before_prepare :extract_schema_properties!

        use_contract! :entity_input

        attachment! :hero_image, image: true

        attachment! :thumbnail, image: true
      end

      # Create an entity and potentially assign its schema properties.
      #
      # @param [HierarchicalEntity] entity
      # @param [{ Symbol => Object }] attributes core attributes to apply
      # @return [void]
      def create_entity!(entity, **attributes)
        attributes[:schema_version] = loaded_schema_version

        assign_attributes! entity, **attributes

        persist_model! entity

        maybe_apply_schema_properties! entity
      end

      # @api private
      # @return [void]
      def extract_schema_properties!
        local_context[:schema_properties] = SafeHash[local_context[:args][:schema_properties]]
      end

      # @api private
      # @return [void]
      def maybe_apply_schema_properties!(entity)
        if local_context[:schema_properties].present?
          apply_schema_properties! entity, local_context[:schema_properties]
        else
          attach_polymorphic_entity! entity
        end
      end
    end
  end
end
