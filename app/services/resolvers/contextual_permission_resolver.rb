# frozen_string_literal: true

module Resolvers
  class ContextualPermissionResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    include Resolvers::PageBasedPagination

    type Types::ContextualPermissionType.connection_type, null: false

    scope { object.contextual_permissions.preload(:roles, :user) }

    option :order, type: Types::ContextualPermissionOrderType, default: "USER_NAME_ASC"

    def apply_order_with_recent(scope)
      scope.order(created_at: :desc)
    end

    def apply_order_with_oldest(scope)
      scope.order(created_at: :asc)
    end

    def apply_order_with_user_name_asc(scope)
      scope.joins(:user).order(User.arel_table[:name].asc)
    end

    def apply_order_with_user_name_desc(scope)
      scope.joins(:user).order(User.arel_table[:name].desc)
    end
  end
end
