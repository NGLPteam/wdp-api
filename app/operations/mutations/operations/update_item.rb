# frozen_string_literal: true

module Mutations
  module Operations
    # Update an {Item}.
    #
    # @see Mutations::UpdateItem
    class UpdateItem
      include MutationOperations::Base
      include Mutations::Shared::UpdatesEntity

      use_contract! :update_item
      use_contract! :entity_visibility

      # @param [Item] item
      # @param [{ Symbol => Object }] attributes core properties for the entity
      # @return [void]
      def call(item:, **attributes)
        authorize item, :update?

        update_entity! item, **attributes
      end
    end
  end
end
