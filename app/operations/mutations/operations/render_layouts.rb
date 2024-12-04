# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::RenderLayouts
    class RenderLayouts
      include MutationOperations::Base

      use_contract! :render_layouts

      # @param [Entity] entity
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(entity:, **attrs)
        authorize entity, :update?

        entity = check_result! entity.render_layouts

        attach! :entity, entity
      end
    end
  end
end
