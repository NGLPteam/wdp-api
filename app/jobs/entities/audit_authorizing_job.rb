# frozen_string_literal: true

module Entities
  # A scheduled job to prune rows in {AuthorizingEntity}.
  #
  # @see Entities::AuditAuthorizing
  class AuditAuthorizingJob < ApplicationJob
    queue_as :maintenance

    unique :until_and_while_executing, lock_ttl: 10.minutes, on_conflict: :log

    # @return [void]
    def perform
      call_operation! "entities.audit_authorizing"
    end
  end
end
