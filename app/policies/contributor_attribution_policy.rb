# frozen_string_literal: true

# @see ContributorAttribution
class ContributorAttributionPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
