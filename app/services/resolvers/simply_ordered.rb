# frozen_string_literal: true

module Resolvers
  # For resolvers that don't have their own order types, fall back to a generic that
  # merely sorts by `created_at` in ascending or descending order. It defaults to `recent`.
  #
  # @see Types::SimpleOrderType
  module SimplyOrdered
    extend ActiveSupport::Concern

    included do
      option :order, type: Types::SimpleOrderType, default: "RECENT"
    end

    def apply_order_with_recent(scope)
      scope.order(created_at: :desc)
    end

    def apply_order_with_oldest(scope)
      scope.order(created_at: :asc)
    end
  end
end
