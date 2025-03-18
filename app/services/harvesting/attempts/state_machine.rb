# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see HarvestAttempt
    class StateMachine
      include Statesman::Machine

      state :pending, initial: true
      state :scheduled
      state :executing
      state :extracted
      state :cancelled

      transition from: :pending, to: :scheduled
      transition from: :pending, to: :executing

      transition from: :scheduled, to: :executing
      transition from: :scheduled, to: :cancelled

      transition from: :executing, to: :extracted

      after_transition(to: :executing) do |attempt|
        attempt.touch(:began_at)
      end

      after_transition(to: :extracted) do |attempt|
        attempt.touch(:ended_at)
      end
    end
  end
end
