# frozen_string_literal: true

require "dry/core/equalizer"
require "dry/core/memoizable"

class VariablePrecisionDate
  include Dry::Core::Equalizer.new(:value, :precision)
  include Dry::Core::Memoizable

  # The level of precision this date affords
  #
  # Can be `:none`, `:year`, `:month, or `:day`, in order of increasing precision.
  Precision = Dry::Types["coercible.symbol"].default(:none).enum(:none, :year, :month, :day)

  HashSchema = Dry::Types["hash"].schema(
    value: Dry::Types["json.date"],
    precision: Precision,
  ).with_key_transform(&:to_sym)

  SQL_PRECISIONS = %w[none year month day].flat_map do |precision|
    [precision, precision.to_s.inspect]
  end.then { |precisions| Regexp.union precisions }

  SQL_REPRESENTATION = /\A\([^,]*,(?:#{SQL_PRECISIONS})?\)\z/.freeze

  PARSEABLE = [self.class, SQL_REPRESENTATION, HashSchema, Dry::Types["json.date"]].freeze

  # @api private
  ENCODER = PG::TextEncoder::Record.new

  # @api private
  DECODER = PG::TextDecoder::Record.new

  include Dry::Initializer[undefined: false].define -> do
    param :raw_value, Dry::Types["json.date"].optional, default: proc { nil }, reader: :private
    param :raw_precision, Precision, default: proc { :none }, reader: :private
  end

  # @!attribute [r] value
  # @return [Date, nil]
  memoize def value
    case precision
    when :day then raw_value
    when :month then raw_value.at_beginning_of_month
    when :year then raw_value.at_beginning_of_year
    end
  end

  # @!attribute [r] precision
  # @return [:none, :year, :month, :day]
  memoize def precision
    raw_value.blank? ? :none : raw_precision
  end

  def day?
    precision == :day
  end

  alias exact? day?

  def inexact?
    !exact?
  end

  def month?
    precision == :month
  end

  def none?
    precision == :none
  end

  def year?
    precision == :year
  end

  def to_date
    value unless none?
  end

  # @return [String] the SQL representation of the
  def to_sql
    ENCODER.encode([value, precision])
  end

  def as_json(*)
    to_sql
  end

  class << self
    # @param [String, Date, Hash, VariablePrecisionDate] value
    # @return [VariablePrecisionDate]
    def parse(value)
      case value
      when ::VariablePrecisionDate
        value
      when SQL_REPRESENTATION
        parse_sql value
      when Date, Dry::Types["json.date"]
        new value, :day
      when VariablePrecisionDate::HashSchema
        new value[:value], value[:precision]
      else
        new nil, :none
      end
    end

    # @param [String] sql_string
    # @return [VariablePrecisionDate]
    def parse_sql(sql_string)
      decoded = DECODER.decode sql_string

      return new(nil, :none) if decoded.blank?

      value = parse_sql_date decoded[0]

      return new(nil, :none) if value.blank?

      precision = parse_sql_precision decoded[1]

      new value, precision
    end

    def from_month(year_value, month_value)
      value = Date.new year_value.to_i, month_value.to_i, 1

      new value, :month
    end

    def from_year(year_value)
      value = Date.new year_value.to_i, 1, 1

      new value, :year
    end

    def none
      new nil, :none
    end

    private

    def parse_sql_date(value)
      Date.parse value
    rescue Date::Error, TypeError
      # :nocov:
      nil
      # :nocov:
    end

    def parse_sql_precision(precision)
      case precision
      when Precision
        Precision[precision]
      else
        # :nocov:
        :none
        # :nocov:
      end
    end
  end
end
