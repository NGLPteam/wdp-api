# frozen_string_literal: true

module Assets
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Kind = ApplicationRecord.dry_pg_enum(:asset_kind, default: "unknown").fallback("unknown")
  end
end
