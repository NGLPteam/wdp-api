# frozen_string_literal: true

module Schemas
  module Orderings
    module Types
      include Dry.Types

      ArelJoin = Instance(::Arel::Nodes::Join)

      ArelJoinMap = Hash.map(String, ArelJoin)

      ArelJoins = Array.of(ArelJoin)

      ArelOrdering = Instance(::Arel::Nodes::Ordering)

      ArelOrderings = Array.of(ArelOrdering)

      ColumnList = Coercible::Array.of(Coercible::Symbol).constrained(min_size: 1)

      VariableDatePath = String.enum(
        "$published$",
        "$issued$",
        "$available$",
        "$accessioned$",
      )
    end
  end
end
