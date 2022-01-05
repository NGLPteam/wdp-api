# frozen_string_literal: true

require_relative "../variable_precision_date"

module GlobalTypes
  # A type for encoding a {::VariablePrecisionDate}. It is registered with ActiveRecord's
  # type map so that variable precision date columns on models are automatically parsed.
  #
  # It can be used by StoreModel objects with `:variable_precision_date`.
  class VariablePrecisionDate < ActiveRecord::Type::Value
    # @param [String] value
    # @return [::VariablePrecisionDate]
    def cast(value)
      ::VariablePrecisionDate.parse value
    end

    # @param [::VariablePrecisionDate] value
    # @return [String] the SQL representation of the variable precision date (e.g. `(2021-01-01,year)`)
    def serialize(value)
      case value
      when VariablePrecisionDate
        value.to_sql
      else
        cast(value).to_sql
      end
    end

    # @param [String] raw_old_value
    # @param [::VariablePrecisionDate] new_value
    def changed_in_place?(raw_old_value, new_value)
      raw_old_value != serialize(new_value)
    end

    # The SQL name for this type.
    # @return [:variable_precision_date]
    def type
      :variable_precision_date
    end
  end
end
