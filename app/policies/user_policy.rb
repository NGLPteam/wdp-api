# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def read?
    return true if record.anonymous? || record == user

    super
  end

  class Scope < Scope
    def resolve
      return scope.all if admin_or_has_allowed_action?("users.read")

      return scope.none if user.anonymous?

      scope.where(id: user.id)
    end
  end
end
