# frozen_string_literal: true

# @see CollectionAttribution
class CollectionAttributionPolicy < ApplicationPolicy
  def show?
    authorized? record.collection, :show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
