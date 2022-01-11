# frozen_string_literal: true

# @see Community
class CommunityPolicy < HierarchicalEntityPolicy
  def read?
    has_admin_or_allowed_action?("communities.read") || super
  end

  def create?
    has_admin_or_allowed_action? "communities.create"
  end

  def update?
    has_admin_or_allowed_action?("communities.update") || super
  end

  def destroy?
    has_admin_or_allowed_action?("communities.delete") || super
  end

  class Scope < Scope
    def resolve
      return scope.all if admin_or_has_allowed_action?("communities.read")

      super
    end
  end
end
