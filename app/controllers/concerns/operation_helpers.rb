# frozen_string_literal: true

# Helpers for performing operations within the scope of a controller request.
module OperationHelpers
  # Perform an operation of a specific name
  #
  # It should be an operation that returns a `Dry::Monad::Result` and does not require
  # a block to be passed, as the result of calling the operation will be passed along
  # to to a `Dry::Matcher::ResultMatcher`.
  #
  # @param [String] name The fully-qualified name of an operation to call within `MeruAPI::Container`.
  # @param [<Object>] args the arguments to call the operation with (if any).
  # @yield [matcher]
  # @yieldparam [Dry::Matcher::ResultMatcher] matcher
  # @yieldreturn [void]
  # @return [void]
  def perform_operation(name, *args, &)
    operation = resolve name

    result = operation.call(*args)

    Dry::Matcher::ResultMatcher.call(result, &)
  end
end
