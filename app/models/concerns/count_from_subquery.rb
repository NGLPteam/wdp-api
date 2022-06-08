# frozen_string_literal: true

# Sometimes we need to get a count on something that has aggregations,
# `DISTINCT ON`, etc. This should handle most cases.
module CountFromSubquery
  extend ActiveSupport::Concern

  class_methods do
    # @param [Boolean] strip_order
    # @return [Integer]
    def count_from_subquery(strip_order: false)
      subquery = all

      subquery = subquery.reorder(nil) if strip_order

      unscoped.from(subquery).count
    end
  end
end
