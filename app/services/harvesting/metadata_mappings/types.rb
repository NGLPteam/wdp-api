# frozen_string_literal: true

module Harvesting
  module MetadataMappings
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      Field = ::Types::HarvestMetadataMappingFieldType.dry_type

      Identifier = Coercible::String.constrained(filled: true)

      Pattern = Coercible::String.constrained(filled: true)

      Struct = Hash.schema(
        field: Field,
        identifier: Identifier,
        pattern: Pattern
      ).with_key_transform(&:to_sym)

      Structs = Coercible::Array.of(Struct)
    end
  end
end
