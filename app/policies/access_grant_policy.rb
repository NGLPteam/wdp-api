# frozen_string_literal: true

class AccessGrantPolicy < ApplicationPolicy
  def initialize(user, record)
    super

    @is_manager = user.anonymous? ? false : record.managers.exists?(user.id)
  end

  # @api private
  def has_admin_or_manages?
    return false if user.anonymous?

    return true if user.has_global_admin_access?

    @is_manager
  end

  alias show? has_admin_or_manages?

  alias index? show?

  alias create? has_admin_or_manages?

  alias update? has_admin_or_manages?

  alias destroy? has_admin_or_manages?

  alias manage_access? has_admin_or_manages?

  class Scope < Scope
    def resolve
      scope.manageable_by user
    end
  end
end
