# frozen_string_literal: true

module Entities
  # Mark a given {Entity} as stale and in need of a re-rendering
  # of all its associated layouts.
  class InvalidateLayouts
    include Dry::Monads[:result]
    include AfterCommitEverywhere

    # @param [HierarchicalEntity] entity
    # @return [Dry::Monads::Success(void)]
    def call(entity)
      after_commit do
        entity.layout_invalidations.create!
      end

      Success()
    end
  end
end
