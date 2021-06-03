# frozen_string_literal: true

class CommunityPolicy < HierarchicalEntityPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
