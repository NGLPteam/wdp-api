# frozen_string_literal: true

# The base policy for authorizing actions in the application.
#
# @abstract
class ApplicationPolicy
  extend Dry::Core::ClassAttributes

  # @!scope class
  # @!attribute [rw] effective_permission_map
  # @return [Roles::Types::EffectivePermissionMap]
  defines :effective_permission_map, type: Roles::Types::EffectivePermissionMap

  effective_permission_map({})

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

  # This permission determines whether a given {#user}
  # has been granted read-access to the {#record}.
  #
  # Specifically, it means the user can read a fuller representation
  # of the record, as opposed to simply being able to {#show? view it}
  # in the frontend.
  #
  #
  # @abstract
  # @see #show?
  def read?
    admin_or_owns_resource?
  end

  def index?
    show?
  end

  # This determines whether an individual record can
  # appear to a given {#user}.
  #
  # @abstract
  # @see #read?
  def show?
    read?
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

  # @!group Effective Permission Grids

  # @return [Roles::AnonymousGrid]
  def effective_access
    Roles::PermissionGridDefiner.new(self.class.effective_available_actions).call do |acl|
      self.class.effective_permission_map.each do |path, predicate|
        allowed = public_send(predicate)

        allowed ? acl.allow!(path) : acl.deny!(path)
      end
    end
  end

  # @!endgroup

  # @!group Hierarchical permissions

  # @abstract
  def create_assets?
    false
  end

  # @abstract
  def create_collections?
    false
  end

  # @abstract
  def create_items?
    false
  end

  # @!endgroup

  def has_admin?
    user.has_global_admin_access?
  end

  def has_allowed_action?(action_name)
    action_name.in? user.allowed_actions
  end

  def has_admin_or_allowed_action?(action_name)
    has_admin? || has_allowed_action?(action_name)
  end

  # @param [ApplicationRecord] record
  # @param [Symbol] query
  # @param [Boolean] admin_always_allowed
  # @param [User, AnonymousUser] pundit_user
  def authorized?(record, query, admin_always_allowed: true, pundit_user: @user)
    return true if admin_always_allowed && pundit_user.has_global_admin_access?

    return false if record.blank?

    policy_for(record, pundit_user:).public_send query
  end

  # Load a sub-policy.
  #
  # @param [ApplicationRecord] record
  # @param [User, AnonymousUser] pundit_user
  # @return [ApplicationPolicy]
  def policy_for(record, pundit_user: @user)
    subpolicies[[record, pundit_user]] ||= Pundit.policy! pundit_user, record
  end

  private

  # @!attribute [r] subpolicies
  # @return [{ (ApplicationRecord, User) => ApplicationPolicy }]
  def subpolicies
    @subpolicies ||= {}
  end

  class << self
    # @return [<String>]
    def effective_available_actions
      effective_permission_map.keys
    end

    # @param [Roles::Types::PermissionName] path
    # @param [Roles::Types::PolicyPredicate] predicate
    # @return [void]
    def effective_permission!(path, predicate)
      merged = effective_permission_map.merge(path => predicate)

      effective_permission_map merged
    end

    def effective_crud_permissions!(scope: "self", read: :read?, create: :create?, update: :update?, delete: :destroy?)
      scopify = ->(name) do
        [scope.presence, name].compact.join(".")
      end

      actions = {}.tap do |h|
        h[scopify["read"]] = read
        h[scopify["create"]] = create
        h[scopify["update"]] = update
        h[scopify["delete"]] = delete
      end.transform_values(&:presence).compact

      actions.each do |path, predicate|
        effective_permission! path, predicate
      end
    end
  end

  # @abstract
  class Scope
    attr_reader :user, :scope

    # @param [User, AnonymousUser] user
    # @param [ActiveRecord::Relation] scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # @abstract
    # @return [ActiveRecord::Relation]
    def resolve
      return scope.none if user.anonymous?

      scope.all
    end

    # @api private
    def resolve_user_owned
      return scope.none if user.anonymous?

      return scope.all if user.has_global_admin_access?

      scope.none
    end

    # @see User#has_allowed_action?
    # @param [String] name
    def has_allowed_action?(name)
      user&.has_allowed_action?(name)
    end

    # @see User#has_global_admin_access?
    def has_global_admin_access?
      user&.has_global_admin_access?
    end

    # @see #has_global_admin_access?
    # @see #has_allowed_action?
    # @param [String] name
    def admin_or_has_allowed_action?(name)
      has_global_admin_access? || has_allowed_action?(name)
    end
  end
end
