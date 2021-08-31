# frozen_string_literal: true

class CollectionContributionPolicy < ApplicationPolicy
  def show?
    authorized? record.collection, :show?
  end

  def create?
    authorized? record.collection, :update?
  end

  def update?
    authorized? record.collection, :update?
  end

  def destroy?
    authorized? record.collection, :update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
