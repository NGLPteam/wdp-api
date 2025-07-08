# frozen_string_literal: true

module JournalSources
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    UNKNOWN = "UNKNOWN"

    KnowableString = String.default(UNKNOWN).fallback(UNKNOWN)

    Mode = Symbol.enum(:unknown, :full, :volume_only)

    OptionalInteger = Coercible::Integer.optional.fallback(nil)

    OptionalString = String.optional.default(nil).fallback(nil)
  end
end
