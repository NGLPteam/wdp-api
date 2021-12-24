# frozen_string_literal: true

module NamedVariableDates
  module Types
    include Dry.Types

    # These variable precision dates are shared across all {ChildEntity} types.
    SHARED = %i[published accessioned available issued].freeze

    # These are an extension of {Shared}, limited to {Collection}s.
    COLLECTION = SHARED.map { |name| :"last_#{name}" }.freeze

    SharedGlobalName = Coercible::Symbol.enum(
      *SHARED
    )

    CollectionGlobalName = Coercible::Symbol.enum(
      *COLLECTION
    )

    GlobalName = Coercible::Symbol.enum(
      *SHARED,
      *COLLECTION
    )
  end
end
