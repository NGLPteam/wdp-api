# frozen_string_literal: true

module VariablePrecision
  class ParseDate
    include Dry::Monads[:do, :result]

    ISO_8601 = /\A\d{4}\D\d{2}\D\d{2}\z/.freeze

    YEAR_INT = ->(o) { o.kind_of?(Integer) && o.to_s.length == 4 }

    YEAR_ONLY = /\A(?<year>\d{4})\z/.freeze

    YEAR_MONTH = /\A(?<year>\d{4})\D(?<month>\d{2})\z/.freeze

    # @param [String, Date, Time] value
    # @return [Dry::Monads::Result]
    def call(value)
      return wrap_none if value.blank?

      return Success(value) if value.kind_of?(VariablePrecisionDate)

      return wrap_day(value.to_date) if datelike? value

      return wrap_day(value) if value.kind_of?(Date)

      case value
      when ISO_8601
        wrap_day value.to_date
      when YEAR_ONLY
        wrap_year Regexp.last_match[:year]
      when YEAR_INT
        wrap_year value
      when YEAR_MONTH
        wrap_month Regexp.last_match[:year], Regexp.last_match[:month]
      when *VariablePrecisionDate::PARSEABLE
        Success VariablePrecisionDate.parse(value)
      else
        wrap_none
      end
    rescue Date::Error
      wrap_none
    end

    private

    def datelike?(value)
      value.kind_of?(Time) || value.kind_of?(DateTime)
    end

    def wrap_day(value)
      wrap value, :day
    end

    def wrap_month(year_value, month_value)
      Success VariablePrecisionDate.from_month(year_value, month_value)
    end

    def wrap_year(year_value)
      Success VariablePrecisionDate.from_year(year_value)
    end

    def wrap_none
      wrap nil, :none
    end

    def wrap(value, precision)
      Success VariablePrecisionDate.new value, precision
    end
  end
end
