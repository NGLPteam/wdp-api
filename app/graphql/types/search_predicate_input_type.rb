# frozen_string_literal: true

module Types
  # @see ::Searching::Operators
  # @see Types::SearchOperatorType
  class SearchPredicateInputType < Types::BaseInputObject
    description <<~TEXT
    A predicate clause for searching entities.

    Each key corresponds to a `SearchOperator`, and multiple keys combined
    in the same predicate will be implicitly `AND`ed together.
    TEXT

    argument :and, "Types::Searching::AndOperatorInputType", required: false do
      description "See `AndOperatorInput`"
    end

    argument :or, "Types::Searching::OrOperatorInputType", required: false do
      description "See `OrOperatorInput`"
    end

    argument :dateEquals, Types::Searching::DateEqualsOperatorInputType, required: false do
      description "See `DateEqualsOperatorInput`"
    end

    argument :dateGTE, Types::Searching::DateGTEOperatorInputType, required: false do
      description "See `DateGTEOperatorInput`"
    end

    argument :dateLTE, Types::Searching::DateLTEOperatorInputType, required: false do
      description "See `DateLTEOperatorInput`"
    end

    argument :equals, Types::Searching::EqualsOperatorInputType, required: false do
      description "See `EqualsOperatorInput`"
    end

    argument :matches, Types::Searching::MatchesOperatorInputType, required: false do
      description "See `MatchesOperatorInput`"
    end

    argument :in_any, Types::Searching::InAnyOperatorInputType, required: false do
      description "See `InAnyOperatorInput`"
    end

    argument :numericGTE, Types::Searching::NumericGTEOperatorInputType, required: false do
      description "See `NumericGTEOperatorInput`"
    end

    argument :numericLTE, Types::Searching::NumericLTEOperatorInputType, required: false do
      description "See `NumericLTEOperatorInput`"
    end

    # @return [<Searching::Operator>]
    def prepare
      to_h.values.compact
    end
  end
end
