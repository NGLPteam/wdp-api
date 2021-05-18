# frozen_string_literal: true

module Resolvers
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
