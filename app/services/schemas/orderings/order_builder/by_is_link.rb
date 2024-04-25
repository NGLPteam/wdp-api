# frozen_string_literal: true

module Schemas
  module Orderings
    module OrderBuilder
      # Builds an `ORDER BY` statement for testing if the {OrderingEntryCandidate} is a link.
      #
      # @api private
      class ByIsLink < Base
        def attributes_for(...)
          cached_attributes
        end

        memoize def cached_attributes
          [
            order_boolean(arel_table[:link_operator].not_eq(nil))
          ]
        end
      end
    end
  end
end
