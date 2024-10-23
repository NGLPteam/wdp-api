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

      Direction = ::Support::GlobalTypes::SimpleSortDirection

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

      PathForStatic = String.enum(*StaticOrderableProperty.pluck(:path))

      PathForProps = String.constrained(format: Schemas::Orderings::OrderBuilder::PROPS_PATTERN)

      Path = String.constrained(format: Schemas::Orderings::OrderBuilder::PATTERN)

      RenderMode = Coercible::String.default("flat").enum("flat", "tree").fallback("flat")

      SelectDirect = Coercible::String.default("children").enum("none", "children", "descendants").fallback("none")
    end
  end
end
