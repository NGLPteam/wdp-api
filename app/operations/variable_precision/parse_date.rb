# frozen_string_literal: true

module VariablePrecision
  # @see VariablePrecisionDate.parse
  class ParseDate
    include Dry::Monads[:do, :result]

    # @param [String, Date, Time] value
    # @return [Dry::Monads::Result]
    def call(value)
      case value
      when ::VariablePrecisionDate
        Success value
      when *::VariablePrecisionDate::PARSEABLE
        Success VariablePrecisionDate.parse(value)
      else
        wrap_none
      end
    rescue Date::Error
      wrap_none
    end

    private

    def wrap_day(value)
      wrap value, :day
    end

    def wrap_none
      wrap nil, :none
    end

    def wrap(value, precision)
      Success VariablePrecisionDate.new value, precision
    end
  end
end
