# frozen_string_literal: true

# @abstract
# @todo Handle anonymous access for hierarchical entities
class HierarchicalEntityPolicy < ApplicationPolicy
  def initialize(user, record)
    super

    @grid = grid_for user, record
  end

  def show?
    admin_or_grid_has? :read
  end

  alias index? show?

  def create?
    admin_or_grid_has? :create
  end

  def update?
    admin_or_grid_has? :update
  end

  def destroy?
    admin_or_grid_has? :destroy
  end

  def manage_roles?
    admin_or_grid_has? :manage_access
  end

  # @!scope private
  # @param [#to_s] name
  # @see Roles::PermissionGrid#[]
  def has_grid?(name)
    @grid[name]
  end

  private

  def admin_or_grid_has?(name)
    return false if user.anonymous?

    return true if user.has_global_admin_access?

    has_grid? name
  end

  def grid_for(user, record)
    composed_role = ComposedPermission.fetch user, record

    composed_role&.grid || Roles::PermissionGrid.new
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
