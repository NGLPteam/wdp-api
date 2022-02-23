# frozen_string_literal: true

module Access
  # @see Access::EnforceAssignments
  class EnforceAssignmentsJob < ApplicationJob
    queue_as :permissions

    unique :until_and_while_executing, lock_ttl: 10.minutes, on_conflict: :log

    # @return [void]
    def perform
      call_operation! "access.enforce_assignments"
    end
  end
end
