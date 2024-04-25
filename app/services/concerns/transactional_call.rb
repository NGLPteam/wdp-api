# frozen_string_literal: true

# A module for callable objects that wraps their `#call` methods in a transaction.
#
# @note This module should always be prepended.
module TransactionalCall
  def call(...)
    wrap_in_transaction do
      super
    end
  end

  # @api private
  # @return [Integer]
  def deadlock_retry_count
    self.class.deadlock_retry_count
  end

  def requires_new_transaction?
    deadlock_retry_count > 0
  end

  # @api private
  # @note this is always true if a deadlock retry count has been set
  def start_new_transaction?
    requires_new_transaction? || self.class.start_new_transaction
  end

  def maybe_retry_deadlocks(deadlock_count: deadlock_retry_count)
    return yield if deadlock_count == 0

    Retryable.retryable(tries: deadlock_retry_count, on: ActiveRecord::Deadlocked) do
      yield
    end
  end

  def wrap_in_transaction(deadlock_count: deadlock_retry_count, requires_new: start_new_transaction?)
    requires_new = deadlock_count > 0 || requires_new

    maybe_retry_deadlocks(deadlock_count:) do
      ApplicationRecord.transaction(requires_new:) do
        yield
      end
    end
  end

  class << self
    def prepended(base)
      base.extend Dry::Core::ClassAttributes
      base.extend TransactionalCall::ClassMethods

      base.defines :deadlock_retry_count, type: Dry::Types["coercible.integer"].constrained(gteq: 0)
      base.defines :start_new_transaction, type: Dry::Types["bool"]

      base.deadlock_retry_count 0

      base.start_new_transaction false
    end
  end

  # Class methods for this prepended module.
  module ClassMethods
    # @return [void]
    def start_new_transaction!
      start_new_transaction false
    end
  end
end
