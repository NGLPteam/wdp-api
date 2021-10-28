# frozen_string_literal: true

require_relative "../variable_precision_date"

module GlobalTypes
  class VariablePrecisionDate < ActiveRecord::Type::Value
    # @param [String] value
    # @return [VariablePrecisionDate]
    def cast(value)
      ::VariablePrecisionDate.parse value
    end

    # @param [VariablePrecisionDate] new_value
    # @return [String] the SQL representation of the variable precision date (e.g. `(2021-01-01,year)`)
    def serialize(value)
      value.to_sql
    end

    # @param [String] raw_old_value
    # @param [VariablePrecisionDate] new_value
    def changed_in_place?(raw_old_value, new_value)
      raw_old_value != serialize(new_value)
    end

    def type
      :variable_precision_date
    end
  end
end
