# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::EntityPurge
    class EntityPurge
      include MutationOperations::Base

      authorizes! :entity, with: :purge?

      use_contract! :entity_purge

      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(entity:)
        entity.purge!(mode: :mark)

        Entities::PurgeJob.perform_later entity

        attach! :entity, entity.reload

        attach! :job_enqueued, true
      end
    end
  end
end
