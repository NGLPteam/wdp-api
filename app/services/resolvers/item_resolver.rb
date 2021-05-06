# frozen_string_literal: true

module Resolvers
  class ItemResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    type Types::ItemType.connection_type, null: false

    scope { object.items }

    option :order, type: Types::SimpleOrderType, default: "RECENT"

    def apply_order_with_recent(scope)
      scope.order(created_at: :desc)
    end

    def apply_order_with_oldest(scope)
      scope.order(created_at: :asc)
    end
  end
end
