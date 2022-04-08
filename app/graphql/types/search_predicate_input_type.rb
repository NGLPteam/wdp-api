# frozen_string_literal: true

module Types
  class SearchPredicateInputType < Types::BaseInputObject
    description <<~TEXT
    A predicate clause for searching entities.
    TEXT

    argument :and, "Types::Searching::AndOperatorInputType", required: false
    argument :or, "Types::Searching::OrOperatorInputType", required: false

    argument :date_gte, Types::Searching::DateGTEOperatorInputType, required: false
    argument :date_lte, Types::Searching::DateLTEOperatorInputType, required: false

    argument :equals, Types::Searching::EqualsOperatorInputType, required: false
    argument :matches, Types::Searching::MatchesOperatorInputType, required: false
    argument :in_any, Types::Searching::InAnyOperatorInputType, required: false

    argument :numeric_gte, Types::Searching::NumericGTEOperatorInputType, required: false
    argument :numeric_lte, Types::Searching::NumericLTEOperatorInputType, required: false

    # @return [<Searching::Operator>]
    def prepare
      to_h.values.compact
    end
  end
end
