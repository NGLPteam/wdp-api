# frozen_string_literal: true

module Graphql
  module PunditHelpers
    def authorize(record, query, policy_class: nil)
      policy = policy_class ? policy_class.new(pundit_user, record) : policy(record)

      raise Pundit::NotAuthorizedError, query: query, record: record, policy: policy unless policy.public_send(query)

      record
    end

    def current_user_admin?
      context[:current_user]&.has_global_admin_access?
    end

    def policy(record)
      Pundit.policy!(pundit_user, record)
    end

    def policy_scope(scope, policy_scope_class: nil)
      policy_scope_class ? policy_scope_class.new(pundit_user, scope).resolve : pundit_policy_scope(scope)
    end

    def pundit_policy_scope(scope)
      Pundit.policy_scope!(pundit_user, scope)
    end

    def pundit_user
      @pundit_user ||= context[:current_user].presence || AnonymousUser.new
    end
  end
end
