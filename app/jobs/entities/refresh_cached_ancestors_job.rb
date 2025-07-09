# frozen_string_literal: true

module Entities
  # @note Runs every 2 minutes
  # @see EntityCachedAncestor
  class RefreshCachedAncestorsJob < ApplicationJob
    queue_as :maintenance

    good_job_control_concurrency_with(
      total_limit: 1
    )

    # @return [void]
    def perform
      EntityCachedAncestor.refresh!
    end
  end
end
