# frozen_string_literal: true

# @see OrderingEntry
class OrderingEntryPolicy < ApplicationPolicy
  always_readable!

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def manage_access?
    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
