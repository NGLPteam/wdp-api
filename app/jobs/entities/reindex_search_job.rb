# frozen_string_literal: true

module Entities
  # @see Schemas::Instances::ExtractCoreTextsJob
  # @see Schemas::Instances::ExtractSearchablePropertiesJob
  class ReindexSearchJob < ApplicationJob
    queue_as :maintenance

    include JobIteration::Iteration

    unique :until_and_while_executing, lock_ttl: 3.hours, on_conflict: :log

    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        ::Entity.real.preload(:hierarchical),
        cursor: cursor,
      )
    end

    # @param [Entity] entity
    # @return [void]
    def each_iteration(entity)
      Schemas::Instances::ExtractCoreTextsJob.perform_later entity.hierarchical
      Schemas::Instances::ExtractSearchablePropertiesJob.perform_later entity.hierarchical
    end
  end
end
