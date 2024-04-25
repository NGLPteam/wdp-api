# frozen_string_literal: true

module Resolvers
  # A resolver for connecting {OrderingEntry ordering entries} to a parent {Ordering}.
  #
  # @see Ordering
  # @see OrderingEntry
  # @see Types::OrderingType
  # @see Types::OrderingEntryType
  # @see Types::OrderingEntrySortModeType
  class OrderingEntryResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    option :order, type: Types::OrderingEntrySortModeType, default: "default",
      description: <<~TEXT
      You can specify the direction to retrieve entries for an ordering.
      INVERSE will be identical to DEFAULT if the ordering is marked constant.
      TEXT

    type Types::OrderingEntryType.connection_type, null: false

    scope { object.ordering_entries.currently_visible }

    def apply_order_with_default(scope)
      scope.in_default_order
    end

    def apply_order_with_inverse(scope)
      scope.in_inverse_order
    end
  end
end
