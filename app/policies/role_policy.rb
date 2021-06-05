# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  def create?
    user.has_global_admin_access?
  end

  def update?
    user.has_global_admin_access?
  end

  def destroy?
    user.has_global_admin_access?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
