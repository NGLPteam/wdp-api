# frozen_string_literal: true

module Mutations
  module Shared
    # Shared logic for updating a {Community}, {Collection}, or {Item}.
    #
    # @see Mutations::Shared::UpdateEntityArguments
    module UpdatesEntity
      extend ActiveSupport::Concern

      include Mutations::Shared::MutatesEntity

      # Update an entity and potentially update its schema properties.
      #
      # @param [HierarchicalEntity] entity
      # @param [{ Symbol => Object }] attributes core attributes to apply
      # @return [void]
      def update_entity!(entity, **attributes)
        assign_attributes! entity, **attributes

        persist_model! entity

        maybe_apply_schema_properties! entity
      end
    end
  end
end
