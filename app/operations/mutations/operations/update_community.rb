# frozen_string_literal: true

module Mutations
  module Operations
    # Update a {Community}.
    #
    # @see Mutations::UpdateCommunity
    class UpdateCommunity
      include MutationOperations::Base
      include Mutations::Shared::UpdatesEntity

      attachment! :logo, image: true

      # @param [Community] community
      # @param [{ Symbol => Object }] attributes core properties for the entity
      # @return [void]
      def call(community:, **attributes)
        authorize community, :update?

        update_entity! community, **attributes
      end
    end
  end
end
