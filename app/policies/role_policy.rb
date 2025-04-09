# frozen_string_literal: true

# The policy for a {Role}.
#
# Because of how this class works, a global admin does _not_ inherently have all
# permissions, and care must be taken to ensure we're checking this policy when
# mutating or assigning roles.
class RolePolicy < ApplicationPolicy
  effective_crud_permissions! create: false

  effective_permission! "roles.assign", :assign?

  def read?
    has_allowed_action? "roles.read"
  end

  # Roles can always be read in GQL.
  def show?
    true
  end

  def create?
    return false if record.for_system?

    has_allowed_action? "roles.create"
  end

  def update?
    return false if record.for_system?

    has_allowed_action? "roles.update"
  end

  def destroy?
    return false if record.for_system?

    has_allowed_action? "roles.delete"
  end

  # Whether the current role can be assigned by the current user.
  def assign?
    # Admin roles can never be assigned
    return false if record.identified_as_admin?

    record.in? user.assignable_roles
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
