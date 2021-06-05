# frozen_string_literal: true

class CommunityPolicy < HierarchicalEntityPolicy
  def create?
    user.has_global_admin_access?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
