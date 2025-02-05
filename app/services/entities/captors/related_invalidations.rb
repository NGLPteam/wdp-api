# frozen_string_literal: true

module Entities
  module Captors
    # @see Entities::Sync
    # @see SyncsEntities
    # @see Entities::InvalidateRelatedLayouts
    class RelatedInvalidations < Abstract
      capture_with! :related_invalidations

      # @param [HierarchicalEntity] entity
      def handle_each!(entity)
        Entities::InvalidateAncestorLayoutsJob.perform_later entity

        Entities::InvalidateDescendantLayoutsJob.perform_later entity
      end
    end
  end
end
