# frozen_string_literal: true

module Entities
  # @see Entities::SyncHierarchies
  class SyncHierarchiesJob < ApplicationJob
    queue_as :hierarchies

    discard_on ActiveRecord::RecordNotFound

    good_job_control_concurrency_with(
      total_limit: 1,
      key: -> { "#{self.class.name}-#{queue_name}-#{arguments.first.id}" }
    )

    # @param [SyncsEntities] descendant
    # @return [void]
    def perform(descendant)
      call_operation!("entities.sync_hierarchies", descendant)
    end
  end
end
