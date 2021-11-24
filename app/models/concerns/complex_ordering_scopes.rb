# frozen_string_literal: true

module ComplexOrderingScopes
  extend ActiveSupport::Concern

  include ArelHelpers

  SORT_DIR = Dry::Types["coercible.string"].fallback("asc").enum("asc", "desc")

  module ClassMethods
    def arel_sort_variable_date(column, dir)
      value = arel_composite_attr(column, :value)

      dir = SORT_DIR[dir]

      if dir == "desc"
        value.desc
      else
        value.asc
      end.then(&:nulls_last)
    end

    def with_sorted_variable_date(column, dir)
      order(arel_sort_variable_date(column, dir))
    end
  end
end
