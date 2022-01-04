# frozen_string_literal: true

# A module for callable objects that wraps their `#call` methods in a transaction.
#
# @note This module should always be prepended.
module TransactionalCall
  def call(*)
    ApplicationRecord.transaction do
      super
    end
  end
end
