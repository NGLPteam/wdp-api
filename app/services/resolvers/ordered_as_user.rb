# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {User} types with {Types::UserOrderType}.
  module OrderedAsUser
    extend ActiveSupport::Concern

    include ScopeUtilities

    included do
      option :order, type: Types::UserOrderType, default: "RECENT"
    end

    def apply_order_with_recent(scope)
      scope.order(created_at: :desc)
    end

    def apply_order_with_oldest(scope)
      scope.order(created_at: :asc)
    end

    def apply_order_with_admins_first(scope)
      scope.by_role_priority.order(name: :asc)
    end

    def apply_order_with_admins_recent(scope)
      scope.by_role_priority.order(created_at: :desc)
    end

    def apply_order_with_name_ascending(scope)
      scope.order(name: :asc)
    end

    def apply_order_with_name_descending(scope)
      scope.order(name: :desc)
    end

    def apply_order_with_email_ascending(scope)
      scope.order(email: :asc)
    end

    def apply_order_with_email_descending(scope)
      scope.order(email: :desc)
    end
  end
end
