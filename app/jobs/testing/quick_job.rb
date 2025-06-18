# frozen_string_literal: true

module Testing
  # This never runs in production. We just use it to test
  # our job timeout logic.
  class QuickJob < ApplicationJob
    max_runtime 1.second

    discard_on JobTimeoutError

    def perform
      sleep 5.0
    end
  end
end
