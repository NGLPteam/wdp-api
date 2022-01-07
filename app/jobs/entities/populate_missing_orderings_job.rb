# frozen_string_literal: true

module Entities
  # Populate all missing {Ordering orderings}.
  class PopulateMissingOrderingsJob < ApplicationJob
    include JobIteration::Iteration

    unique :until_and_while_executing, lock_ttl: 3.hours, on_conflict: :log

    queue_as :maintenance

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        Entity.real.with_missing_orderings,
        cursor: cursor,
      )
    end

    # @param [Entity] entity
    # @return [void]
    def each_iteration(entity)
      call_operation! "schemas.instances.populate_orderings", entity.entity
    end
  end
end
