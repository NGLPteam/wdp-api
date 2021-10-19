# frozen_string_literal: true

module Users
  class SyncTestingJob < ApplicationJob
    queue_as :maintenance

    # @param [User] user
    # @return [void]
    def perform(user)
      user.sync_testing!.value!
    end
  end
end
