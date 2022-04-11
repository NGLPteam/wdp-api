# frozen_string_literal: true

module Types
  # @see ::Searching::Operators
  # @see Types::SearchPredicateInputType.
  class SearchOperatorType < Types::BaseEnum
    description <<~TEXT
    These operators serve as keys for `SearchPredicateInput`.
    TEXT

    value "and", value: "and" do
      description "See `AndOperatorInput`"
    end

    value "or", value: "or" do
      description "See `OrOperatorInput`"
    end

    value "equals", value: "equals" do
      description "See `EqualsOperatorInput`"
    end

    value "matches", value: "matches" do
      description "See `MatchesOperatorInput`"
    end

    value "inAny", value: "in_any" do
      description "See `InAnyOperatorInput`"
    end

    value "dateEquals", value: "date_equals" do
      description "See `DateEqualsOperatorInput`"
    end

    value "dateGTE", value: "date_gte" do
      description "See `DateGTEOperatorInput`"
    end

    value "dateLTE", value: "date_lte" do
      description "See `DateLTEOperatorInput`"
    end

    value "numericGTE", value: "numeric_gte" do
      description "See `NumericGTEOperatorInput`"
    end

    value "numericLTE", value: "numeric_lte" do
      description "See `NumericLTEOperatorInput`"
    end
  end
end
