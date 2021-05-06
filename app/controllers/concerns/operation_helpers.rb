# frozen_string_literal: true

module OperationHelpers
  def perform_operation(name, *args, &block)
    operation = resolve name

    result = operation.call(*args)

    Dry::Matcher::ResultMatcher.call(result, &block)
  end
end
