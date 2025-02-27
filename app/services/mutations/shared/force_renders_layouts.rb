# frozen_string_literal: true

module Mutations
  module Shared
    module ForceRendersLayouts
      extend ActiveSupport::Concern

      # @param [<HierarchicalEntity>] entities
      # @return [void]
      def force_render_layouts_for!(*entities)
        entities.flatten!

        entities.each do |entity|
          entity.render_layouts!

          entity.invalidate_related_layouts!
        end
      end
    end
  end
end
