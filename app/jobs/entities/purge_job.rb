# frozen_string_literal: true

module Entities
  # @see Entities::Purge
  # @see Entities::Purger
  class PurgeJob < ApplicationJob
    queue_as :purging

    good_job_control_concurrency_with(
      total_limit: 1,
      key: -> { "#{self.class.name}-#{arguments.first.entity_id}" }
    )

    # @param [HierarchicalEntity] entity
    # @return [void]
    def perform(entity)
      call_operation!("entities.purge", entity)
    end
  end
end
