# frozen_string_literal: true

# @see AccessGrantPolicy
class AccessGrantPolicy < ApplicationPolicy
  def initialize(user, record)
    super

    @for_admin_role = record.role.try(:identified_as_admin?)
    @is_manager = record.has_manager? user
  end

  def read?
    has_admin_or_manages?
  end

  def show?
    has_admin_or_manages?
  end

  def create?
    has_admin_or_manages?(mutates: true)
  end

  # Access grants are not updatable by anyone.
  def update?
    false
  end

  def destroy?
    has_admin_or_manages?(mutates: true)
  end

  def manage_access?
    false
  end

  private

  # @return [Boolean]
  attr_reader :for_admin_role

  alias for_admin_role? for_admin_role

  def for_self?
    record.subject == user
  end

  # @api private
  def has_admin_or_manages?(mutates: false)
    return false if user.anonymous?

    return false if mutates && (for_admin_role? || for_self?)

    return true if user.has_global_admin_access?

    @is_manager
  end

  class Scope < Scope
    def resolve
      scope.manageable_by user
    end
  end
end
