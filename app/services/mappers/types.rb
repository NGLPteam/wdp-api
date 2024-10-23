# frozen_string_literal: true

module Mappers
  module Types
    include Dry.Types

    include Support::EnhancedTypes

    DryType = Instance(::Dry::Types::Type)

    Nulls = Coercible::String.default("last").enum("last", "first").fallback("last")
  end
end
