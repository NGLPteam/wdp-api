# frozen_string_literal: true

module Mutations
  module Shared
    # Shared logic for creating a {Community}, {Collection}, or {Item}.
    #
    # @see Mutations::Shared::CreateEntityArguments
    module CreatesEntity
      extend ActiveSupport::Concern

      include Mutations::Shared::AssignsSchemaVersion
      include Mutations::Shared::MutatesEntity

      # Create an entity and potentially assign its schema properties.
      #
      # @see #persist_entity!
      # @param [HierarchicalEntity] entity
      # @param [{ Symbol => Object }] attributes core attributes to apply
      # @return [void]
      def create_entity!(entity, **attributes)
        attributes[:schema_version] = loaded_schema_version

        persist_entity! entity, **attributes
      end
    end
  end
end
