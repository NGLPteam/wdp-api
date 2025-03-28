# frozen_string_literal: true

module Mutations
  module Operations
    # Update a {Collection}.
    #
    # @see Mutations::UpdateCollection
    class UpdateCollection
      include MutationOperations::Base
      include Mutations::Shared::UpdatesEntity

      authorizes! :collection, with: :update?

      use_contract! :update_collection
      use_contract! :entity_visibility

      # @param [Collection] collection
      # @param [{ Symbol => Object }] attributes core properties for the entity
      # @return [void]
      def call(collection:, **attributes)
        update_entity! collection, **attributes
      end
    end
  end
end
