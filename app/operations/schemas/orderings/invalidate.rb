# frozen_string_literal: true

module Schemas
  module Orderings
    # Mark an ordering as stale and in need of being refreshed.
    #
    # @see OrderingInvalidation
    class Invalidate
      include Dry::Monads[:result]

      # @param [Ordering] ordering
      # @param [ActiveSupport::TimeWithZone] time
      # @return [Dry::Monads::Success(void)]
      def call(ordering, stale_at: Time.current)
        ordering_id = ordering.id

        tuple = { ordering_id:, stale_at:, }

        OrderingInvalidation.insert(tuple, returning: nil)

        Success()
      end
    end
  end
end
