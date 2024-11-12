# frozen_string_literal: true

module Templates
  module Tags
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      ArgName = Coercible::Symbol.constrained(filled: true)

      ArgNames = Coercible::Array.of(ArgName)
    end
  end
end
