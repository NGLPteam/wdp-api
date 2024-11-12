# frozen_string_literal: true

module Utility
  module Types
    include Dry::Core::Constants
    include Dry.Types

    extend Support::EnhancedTypes

    Callable = Interface(:to_proc)

    MethodName = Coercible::Symbol.constrained(format: /\A[a-z][a-z0-9_]+\z/i)

    MessageFormat = Coercible::String.constrained(filled: true)

    MessageKey = Coercible::Symbol.constrained(format: /\A[a-z][a-z0-9_]+\z/i)

    MessageKeys = Coercible::Array.of(MessageKey).default(EMPTY_ARRAY)

    MessageMapValue = MethodName | Callable

    MessageKeyMap = Hash.map(MessageKey, MessageMapValue)
  end
end
