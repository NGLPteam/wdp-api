# frozen_string_literal: true

module Entities
  # Populate all missing {Ordering orderings}.
  class PopulateMissingOrderingsJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    unique_job! by: :job

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        Entity.real.with_missing_orderings,
        cursor:,
      )
    end

    # @param [Entity] entity
    # @return [void]
    def each_iteration(entity)
      call_operation! "schemas.instances.populate_orderings", entity.entity
    end
  end
end
