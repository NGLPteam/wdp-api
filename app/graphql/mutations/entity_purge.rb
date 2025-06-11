# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::EntityPurge
  class EntityPurge < Mutations::BaseMutation
    description <<~TEXT
    Purge an entity and **all** of its descendants.

    Depending on the entity, this can be very destructive and should be
    used with caution.

    The deletion will be backgrounded, so there will be a delay between
    calling this mutation and all the descendants actually being removed.
    TEXT

    field :entity, Types::EntityType, null: true do
      description <<~TEXT
      The root entity that is to be purged.

      Note that it may not exist for very long.
      TEXT
    end

    field :job_enqueued, Boolean, null: true do
      description <<~TEXT
      Whether or not a job was enqueued.
      TEXT
    end

    argument :entity_id, ID, loads: Types::EntityType, required: true do
      description <<~TEXT
      The entity to destroy.
      TEXT
    end

    performs_operation! "mutations.operations.entity_purge", destroy: true
  end
end
