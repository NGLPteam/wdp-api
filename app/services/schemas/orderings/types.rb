# frozen_string_literal: true

module Schemas
  module Orderings
    module Types
      include Dry.Types

      ColumnList = Coercible::Array.of(Coercible::Symbol).constrained(min_size: 1)
    end
  end
end
