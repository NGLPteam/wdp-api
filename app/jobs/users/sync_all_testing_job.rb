# frozen_string_literal: true

module Users
  class SyncAllTestingJob < ApplicationJob
    include JobIteration::Iteration

    unique_job! by: :job

    queue_as :maintenance

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        User.testing,
        cursor:
      )
    end

    # @param [User] user
    # @return [void]
    def each_iteration(user)
      Users::SyncTestingJob.perform_later user
    end
  end
end
