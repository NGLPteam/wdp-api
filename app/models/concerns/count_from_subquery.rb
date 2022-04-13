# frozen_string_literal: true

# Sometimes we need to get a count on something that has aggregations,
# `DISTINCT ON`, etc. This should handle most cases.
module CountFromSubquery
  extend ActiveSupport::Concern

  class_methods do
    # @return [Integer]
    def count_from_subquery
      unscoped.from(all).count
    end
  end
end
