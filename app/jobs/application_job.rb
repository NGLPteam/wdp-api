# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  extend Dry::Core::ClassAttributes

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  defines :advisory_lock_key, type: AppTypes::String

  advisory_lock_key "application_job"

  defines :advisory_lock_timeout, type: AppTypes::Integer

  advisory_lock_timeout 60

  defines :advisory_lock_retry_wait, type: AppTypes.Instance(ActiveSupport::Duration)

  advisory_lock_retry_wait 10.seconds

  def call_operation!(name, *args)
    WDPAPI::Container[name].call(*args).value!
  end

  # @!group Advisory Lock Methods

  # @api private
  # @return [void]
  def advisory_locked!
    result = FakeVisitor.with_advisory_lock_result advisory_lock_key, timeout_seconds: advisory_lock_timeout do
      yield
    end

    retry_job wait: advisory_lock_retry_wait unless result.lock_was_acquired?
  end

  # @abstract
  # @return [String]
  def advisory_lock_key
    self.class.advisory_lock_key
  end

  def advisory_lock_retry_wait
    self.class.advisory_lock_retry_wait
  end

  def advisory_lock_timeout
    self.class.advisory_lock_timeout
  end

  # @!endgroup

  class << self
    def inherited(subclass)
      super if defined?(super)

      subclass.advisory_lock_key subclass.name.underscore
    end
  end
end
