# frozen_string_literal: true

module FrozenArel
  extend ActiveSupport::Concern

  include ArelHelpers

  included do
    extend Dry::Core::ClassAttributes

    defines :default_sql_values, type: Dry::Types["array"].of(Dry::Types["symbol"])
  end

  # @param [Symbol] key
  # @return [Arel::Nodes::Node]
  def to_sql_value(key)
    arel_quote self[key]
  end

  # @param [<Symbol>] key
  # @return [<Arel::Nodes::Node>]
  def to_values(*keys)
    keys.flatten!

    if keys.blank?
      return [] if self.class.default_sql_values.blank?

      return to_values(*self.class.default_sql_values)
    end

    keys.map do |key|
      to_sql_value key
    end
  end

  private

  def arel_table
    @arel_table ||= ->(key) { to_sql_value(key) }
  end

  def arel_column_matcher
    @arel_column_matcher ||= ->(o) { attributes.key?(o.to_s) }
  end

  class_methods do
    # @param [<Symbol>] key
    # @return [Arel::Nodes::ValuesList]
    def to_values_list(*keys)
      sqlized = to_values(*keys).map do |row|
        row.map do |value|
          case value
          when Arel::Nodes::Quoted then value.expr
          else
            value
          end
        end
      end

      Arel::Nodes::ValuesList.new sqlized
    end

    # @param [<Symbol>] key
    # @return [<<Arel::Nodes::Node>>]
    def to_values(*keys)
      all.map do |record|
        record.to_values(*keys)
      end
    end
  end
end
