# frozen_string_literal: true

module Access
  # @see Access::EnforceAssignments
  class EnforceAssignmentsJob < ApplicationJob
    queue_as :permissions

    unique_job! by: :job

    # @return [void]
    def perform
      call_operation! "access.enforce_assignments"
    end
  end
end
