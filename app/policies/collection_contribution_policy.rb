# frozen_string_literal: true

class CollectionContributionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
