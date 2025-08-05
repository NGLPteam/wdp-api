# frozen_string_literal: true

# @see ItemAttribution
class ItemAttributionPolicy < ApplicationPolicy
  def show?
    authorized? record.item, :show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
