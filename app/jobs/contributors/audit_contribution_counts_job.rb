# frozen_string_literal: true

module Contributors
  # @see Contributors::AuditContributionCounts
  class AuditContributionCountsJob < ApplicationJob
    queue_as :maintenance

    # @params (see Contributors::AuditContributionCounts#call)
    # @return [void]
    def perform(**options)
      call_operation! "contributors.audit_contribution_counts", **options
    end
  end
end
