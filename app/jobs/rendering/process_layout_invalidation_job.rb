# frozen_string_literal: true

module Rendering
  class ProcessLayoutInvalidationJob < ApplicationJob
    queue_as :layouts

    good_job_control_concurrency_with(
      perform_limit: 1,
      key: -> { "#{self.class.name}-#{queue_name}-#{arguments.first.entity_id}" }
    )

    # @param [LayoutInvalidation] layout_invalidation
    # @return [void]
    def perform(layout_invalidation)
      layout_invalidation.process!
    end
  end
end
