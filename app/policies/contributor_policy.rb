# frozen_string_literal: true

class ContributorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.anonymous?

      scope.all
    end
  end
end
