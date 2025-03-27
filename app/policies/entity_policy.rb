# frozen_string_literal: true

# @see Entity
class EntityPolicy < EntityChildRecordPolicy
  class Scope < Scope
    def resolve
      return scope.all if admin_or_has_allowed_action?("admin.access")

      scope.currently_visible
    end
  end
end
