# frozen_string_literal: true

# Most control over a page is determined by a user's access to
# `update` the parent entity.
class PagePolicy < ApplicationPolicy
  # @param [User, AnonymousUser] user
  # @param [Page] record
  def initialize(user, record)
    super

    @grid = grid_for user, record
  end

  def show?
    has_admin_or_permission? :read
  end

  alias index? show?

  def create?
    has_admin_or_permission? :update
  end

  def update?
    has_admin_or_permission? :update
  end

  def destroy?
    has_admin_or_permission? :update
  end

  def manage_access?
    has_admin_or_permission? :manage_access
  end

  private

  # @param [User, AnonymousUser] user
  # @param [Page] record
  # @return [Roles::PermissionGrid]
  def grid_for(user, record)
    composed_role = ContextualPermission.fetch user, record.entity

    composed_role&.grid || Roles::EntityPermissionGrid.new
  end

  # @param [#to_s] name
  def has_admin_or_permission?(name)
    return false if user.anonymous?

    return true if user.has_global_admin_access?

    has_grid? name
  end

  # @param [#to_s] name
  # @see Roles::PermissionGrid#[]
  def has_grid?(name)
    @grid[name]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
