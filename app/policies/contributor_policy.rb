# frozen_string_literal: true

class ContributorPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    has_admin_or_allowed_action? "contributors.create"
  end

  def update?
    has_admin_or_allowed_action?("contributors.update") || super
  end

  def destroy?
    has_admin_or_allowed_action?("contributors.delete") || super
  end

  class Scope < Scope
    def resolve
      return scope.none if user.anonymous?

      scope.all
    end
  end
end
