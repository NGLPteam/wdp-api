# frozen_string_literal: true

module Entities
  # Mark a given entity's ancestors and descendants as stale.
  #
  # @see Entities::Captors::RelatedInvalidations
  # @see Entities::InvalidateAncestorLayoutsJob
  # @see Entities::InvalidateDescendantLayoutsJob
  class InvalidateRelatedLayouts
    include Dry::Monads[:result]
    include Entities::Captors::RelatedInvalidations::Interface

    # @param [HierarchicalEntity] entity
    # @return [Dry::Monads::Success(void)]
    def call(entity)
      unless related_invalidations_captured?(entity)
        Entities::InvalidateAncestorLayoutsJob.perform_later entity

        Entities::InvalidateDescendantLayoutsJob.perform_later entity
      end

      Success()
    end
  end
end
