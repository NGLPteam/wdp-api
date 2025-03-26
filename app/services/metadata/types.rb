# frozen_string_literal: true

module Metadata
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    EnumeratedStringList = Coercible::Array.of(Coercible::String.constrained(filled: true))

    NamespacePrefix = String.constrained(filled: true) | Nil

    NamespaceValue = String.constrained(filled: true)

    NamespaceMap = Hash.map(NamespacePrefix, NamespaceValue)
  end
end
