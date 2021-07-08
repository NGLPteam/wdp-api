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
    admin_or_grid_has? :delete
  end

  def manage_access?
    admin_or_grid_has? :manage_access
  end

  # @!scope private
  # @param [#to_s] name
  # @see Roles::PermissionGrid#[]
  def has_grid?(name)
    @grid[name]
  end

  # @todo scoped asset permissions
  def create_assets?
    true
  end

  def create_collections?
    return true if user.has_global_admin_access?

    has_hierarchical_scoped_permission? :collections, :create
  end

  def create_items?
    return true if user.has_global_admin_access?

    has_hierarchical_scoped_permission? :items, :create
  end

  # @!scope private
  # @param [#to_s] scope_name e.g. "collections", "items"
  # @param [#to_s] permission_name e.g. "read", "create"
  def has_hierarchical_scoped_permission?(scope_name, permission_name)
    action_name = "#{scope_name}.#{permission_name}"

    AccessGrant.for_user(user).with_allowed_action?(name: action_name, entity: record)
  end

  private

  def admin_or_grid_has?(name)
    return false if user.anonymous?

    return true if user.has_global_admin_access?

    has_grid? name
  end

  def grid_for(user, record)
    composed_role = ContextualPermission.fetch user, record

    composed_role&.grid || Roles::EntityPermissionGrid.new
  end

  class Scope < Scope
    def resolve
      return scope.all if user.has_global_admin_access?

      return scope.none if user.anonymous?

      scope.with_permitted_actions_for(user, "self.read")
    end
  end
end
