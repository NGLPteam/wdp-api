# frozen_string_literal: true

# @abstract
class ApplicationJob < ActiveJob::Base
  extend Dry::Core::ClassAttributes

  include GoodJob::ActiveJobExtensions::Concurrency

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  def call_operation!(name, ...)
    MeruAPI::Container[name].call(...).value!
  end

  class << self
    def unique_job!(by: :first_arg, total_limit: 1)
      key = unique_job_key_for!(by:)

      good_job_control_concurrency_with(
        key:,
        enqueue_limit: 1,
        enqueue_throttle: [10, 1.minute],
        total_limit:
      )
    end

    # @api private
    # @return [Proc]
    def unique_job_key_for!(by:)
      # :nocov:
      case by
      when :first_arg
        -> { "#{self.class.name}-#{arguments.first}" }
      when :job
        -> { "#{self.class.name}-instance" }
      else
        -> { "#{self.class.name}-#{queue_name}-#{arguments.inspect}" }
      end
    end
  end
end
