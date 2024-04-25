# frozen_string_literal: true

module Entities
  # A scheduled job to prune rows in {AuthorizingEntity}.
  #
  # @see Entities::AuditAuthorizing
  class AuditAuthorizingJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      call_operation! "entities.audit_authorizing"
    end
  end
end
