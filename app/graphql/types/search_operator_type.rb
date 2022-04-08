# frozen_string_literal: true

module Types
  class SearchOperatorType < Types::BaseEnum
    value "AND", value: "and"
    value "OR", value: "or"

    value "EQUALS", value: "equals"
    value "MATCHES", value: "matches"
    value "IN_ANY", value: "in_any"

    value "DATE_EQUALS", value: "date_equals"
    value "DATE_GTE", value: "date_gte"
    value "DATE_LTE", value: "date_lte"

    value "NUMERIC_GTE", value: "numeric_gte"
    value "NUMERIC_LTE", value: "numeric_lte"
  end
end
