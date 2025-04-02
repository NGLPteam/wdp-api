# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def read?
    return true if record.anonymous? || record == user

    super
  end

  def reset_password?
    return true if authenticated_self_action?

    has_admin_or_allowed_action?("users.update")
  end

  def authenticated_self_action?
    return false if record.anonymous? || user.anonymous?

    record == user
  end

  class Scope < Scope
    def resolve
      return scope.all if admin_or_has_allowed_action?("users.read")

      return scope.none if user.anonymous?

      scope.where(id: user.id)
    end
  end
end
