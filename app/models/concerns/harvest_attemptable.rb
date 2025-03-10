# frozen_string_literal: true

# @see Types::HarvestAttemptableType
module HarvestAttemptable
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  # @see Harvesting::Attempts::Create
  # @see Harvesting::Attempts::Creator
  monadic_operation! def create_attempt(...)
    call_operation("harvesting.attempts.create", self, ...)
  end
end
