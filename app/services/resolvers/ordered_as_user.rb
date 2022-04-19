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
      scope.recent
    end

    def apply_order_with_oldest(scope)
      scope.oldest
    end

    def apply_order_with_admins_first(scope)
      scope.by_role_priority.with_name_ascending
    end

    def apply_order_with_admins_last(scope)
      scope.by_inverse_role_priority.with_name_descending
    end

    def apply_order_with_admins_recent(scope)
      scope.by_role_priority.recent
    end

    def apply_order_with_admins_oldest(scope)
      scope.by_inverse_role_priority.oldest
    end

    def apply_order_with_name_ascending(scope)
      scope.with_name_ascending
    end

    def apply_order_with_name_descending(scope)
      scope.with_name_descending
    end

    def apply_order_with_email_ascending(scope)
      scope.with_name_ascending
    end

    def apply_order_with_email_descending(scope)
      scope.with_name_descending
    end
  end
end
