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

      OrderingFilter = Instance(Schemas::Associations::OrderingFilter).constructor do |value|
        case value
        when Schemas::Associations::OrderingFilter then value
        when OrderingFilterOptions
          Schemas::Associations::OrderingFilter.new(value)
        else
          value
        end
      end

      OrderingFilterOptions = Hash.schema({
        namespace: String,
        identifier: String,
        version?: String
      }).with_key_transform(&:to_sym)

      OrderingFilters = Array.of(OrderingFilter)
    end
  end
end
