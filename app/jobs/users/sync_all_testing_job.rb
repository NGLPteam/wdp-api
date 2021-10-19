# frozen_string_literal: true

module Users
  class SyncAllTestingJob < ApplicationJob
    include JobIteration::Iteration

    unique :until_and_while_executing, lock_ttl: 3.hours, on_conflict: :log

    queue_as :maintenance

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        User.testing,
        cursor: cursor
      )
    end

    # @param [User] user
    # @return [void]
    def each_iteration(user)
      Users::SyncTestingJob.perform_later user
    end
  end
end
