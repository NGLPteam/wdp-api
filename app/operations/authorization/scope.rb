# frozen_string_literal: true

module Authorization
  class Scope
    include Dry::Monads[:result]

    def call(user, scope, policy_scope_class:)
      policy_scope_class ? policy_scope_class.new(user, scope).resolve : ::Pundit.policy_scope!(user, scope)
    end
  end
end
