# frozen_string_literal: true

# The base policy for authorizing actions in the application.
#
# @abstract
class ApplicationPolicy
  # @return [ApplicationRecord]
  attr_reader :record

  # @return [User, AnonymousUser]
  attr_reader :user

  # @param [User, AnonymousUser] user
  # @param [ApplicationRecord] record
  def initialize(user, record)
    @user = user || AnonymousUser.new
    @record = record
  end

  def index?
    show?
  end

  def show?
    admin_or_owns_resource?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    admin_or_owns_resource?
  end

  def edit?
    update?
  end

  def destroy?
    admin_or_owns_resource?
  end

  def manage_access?
    user.has_global_admin_access?
  end

  def admin_or_owns_resource?
    return false if user.anonymous?

    return true if user.has_global_admin_access?

    if record.kind_of?(User)
      user == record
    elsif record.respond_to?(:user_id)
      record.user_id == user.id
    elsif record.respond_to?(:user)
      record.user == user
    else
      false
    end
  end

  # @!group Hierarchical permissions

  def create_assets?
    false
  end

  def create_collections?
    false
  end

  def create_items?
    false
  end

  # @!endgroup

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none if user.anonymous?

      scope.all
    end

    def resolve_user_owned
      return scope.none if user.anonymous?

      return scope.all if user.has_global_admin_access?

      scope.none
    end

    def has_allowed_action?(name)
      user&.has_allowed_action?(name)
    end

    def has_global_admin_access?
      user&.has_global_admin_access?
    end

    def admin_or_has_allowed_action?(name)
      has_global_admin_access? || has_allowed_action?(name)
    end
  end
end
