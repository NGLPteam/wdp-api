# frozen_string_literal: true

module Entities
  # @see Entities::AuditHierarchies
  class AuditHierarchiesJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      call_operation! "entities.audit_hierarchies"
    end
  end
end
