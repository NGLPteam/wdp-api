# frozen_string_literal: true

class CollectionPolicy < HierarchicalEntityPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
