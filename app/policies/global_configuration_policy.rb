# frozen_string_literal: true

class GlobalConfigurationPolicy < ApplicationPolicy
  # Anyone can read global configurations for the most part, as
  # things like the site title, color scheme, and font scheme
  # need to be accessible even to an anonymous user.
  #
  # Privileged attributes will be implemented on a more granular
  # level when they arrive.
  def show?
    true
  end

  # No one can create global configurations. There is only one.
  def create?
    false
  end

  # A user must be a global admin or have been specifically granted
  # `settings.update` permissions in order to alter the settings.
  def update?
    return false if user.anonymous?

    has_admin_or_allowed_action?("settings.update")
  end

  # No one can destroy global configurations.
  def destroy?
    false
  end

  # @api private
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
