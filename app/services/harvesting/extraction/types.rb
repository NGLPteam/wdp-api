# frozen_string_literal: true

module Harvesting
  module Extraction
    module Types
      include Dry.Types

      include Support::EnhancedTypes

      Assigns = Coercible::Hash.map(Coercible::String, Any)

      SchemaPropertyType = ApplicationRecord.dry_pg_enum(:schema_property_type, default: "unknown").fallback("unknown")

      SymbolList = Coercible::Array.of(Coercible::Symbol)
    end
  end
end
