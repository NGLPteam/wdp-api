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
        entity_id = entity.to_encoded_id

        entity.purge!(mode: :mark)

        Entities::PurgeJob.perform_later entity

        attach! :destroyed_id, entity_id

        attach! :entity, entity.reload

        attach! :job_enqueued, true
      end
    end
  end
end
