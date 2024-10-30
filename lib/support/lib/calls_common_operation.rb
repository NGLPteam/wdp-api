# frozen_string_literal: true

module Support
  # A module that gives you a `do_for!` decorator
  module CallsCommonOperation
    extend ActiveSupport::Concern
    extend DefinesMonadicOperation

    # @param [String] operation_name
    # @return [Object]
    monadic_matcher! def call_operation(operation_name, ...)
      ::Common::Container[operation_name].(...)
    end
  end
end
