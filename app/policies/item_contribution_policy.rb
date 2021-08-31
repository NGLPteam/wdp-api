# frozen_string_literal: true

class ItemContributionPolicy < ApplicationPolicy
  def show?
    authorized? record.item, :show?
  end

  def create?
    authorized? record.item, :update?
  end

  def update?
    authorized? record.item, :update?
  end

  def destroy?
    authorized? record.item, :update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
