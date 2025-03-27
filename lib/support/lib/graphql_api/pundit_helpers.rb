# frozen_string_literal: true

module Support
  module GraphQLAPI
    module PunditHelpers
      extend ActiveSupport::Concern

      ANONYMOUS = ::AnonymousUser.new

      # @param [ApplicationRecord] record
      # @param [Symbol] query
      # @param [Class<ApplicationPolicy>] policy_class
      # @raise [Pundit::NotAuthorizedError]
      # @return [ApplicationRecord]
      def authorize(record, query, policy_class: nil)
        policy = policy_class ? policy_class.new(pundit_user, record) : policy(record)

        raise(Pundit::NotAuthorizedError, query:, record:, policy:) unless policy.public_send(query)

        record
      end

      # @param [ApplicationRecord] record
      # @param [Symbol] query
      # @param [Class<ApplicationPolicy>] policy_class
      def authorize_action?(record, query, policy_class: nil)
        policy = policy_class ? policy_class.new(pundit_user, record) : policy(record)

        policy.public_send(query)
      end

      # @param [ApplicationRecord] record
      def policy(record)
        Pundit.policy!(pundit_user, record)
      end

      # @param [ApplicationRecord, ActiveRecord::Relation] scope
      # @param [Class<ApplicationPolicy::Scope>] policy_scope_class
      # @return [ActiveRecord::Relation]
      def policy_scope(scope, policy_scope_class: nil)
        policy_scope_class ? policy_scope_class.new(pundit_user, scope).resolve : pundit_policy_scope(scope)
      end

      # @param [ApplicationRecord, ActiveRecord::Relation] scope
      def pundit_policy_scope(scope)
        Pundit.policy_scope!(pundit_user, scope)
      end

      # @return [Identities::Current]
      def pundit_user
        @pundit_user ||= context[:current_user].presence || ANONYMOUS
      end

      class_methods do
        # @param [ApplicationRecord] record
        # @param [Symbol] query
        # @param [Hash] context
        # @param [Class<ApplicationPolicy>] policy_class
        # @raise [Pundit::NotAuthorizedError]
        # @return [ApplicationRecord]
        def pundit_authorize!(record, query, context, policy_class: nil)
          current_user = context[:current_user] || ANONYMOUS

          policy = policy_class ? policy_class.new(current_user, record) : Pundit.policy!(current_user, record)

          raise(Pundit::NotAuthorizedError, query:, record:, policy:) unless policy.public_send(query)

          return record
        end

        # @see .pundit_authorize!
        def pundit_authorized?(...)
          pundit_authorize!(...)
        rescue Pundit::NotAuthorizedError
          false
        else
          true
        end
      end
    end
  end
end
