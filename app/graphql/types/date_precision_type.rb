# frozen_string_literal: true

module Types
  class DatePrecisionType < Types::BaseEnum
    description "This describes the level of precision a VariablePrecisionDate has, in increasing order of specificity."

    value "NONE", value: :none
    value "YEAR", value: :year
    value "MONTH", value: :month
    value "DAY", value: :day
  end
end
