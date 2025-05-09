# frozen_string_literal: true

# The base policy for authorizing actions in the application.
#
# @abstract
class ApplicationPolicy
  extend Dry::Core::ClassAttributes

  defines :always_readable, :readable_in_dev, type: Roles::Types::Bool

  always_readable false

  readable_in_dev false

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

  def always_readable?
    self.class.always_readable
  end

  def readable_in_dev?
    self.class.readable_in_dev && Rails.env.development?
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
    always_readable? || readable_in_dev? || admin_or_owns_resource?
  end

  # Sometimes we need to allow read access specifically for use with mutation arguments
  # in a way that differs from normal read access. This happens in other projects, but
  # not here yet. This is here for support with {Types::AbstractModel.authorized?}.
  #
  # For the sake of mutations, assume arguments provided can always be read and worry
  # about authorizing within the context of the mutation.
  def read_for_mutation?
    true
  end

  def index?
    # :nocov:
    always_readable? || show?
    # :nocov:
  end

  # This determines whether an individual record can
  # appear to a given {#user}.
  #
  # @abstract
  # @see #read?
  def show?
    always_readable? || read?
  end

  def create?
    false
  end

  def new?
    # :nocov:
    create?
    # :nocov:
  end

  def update?
    admin_or_owns_resource?
  end

  def edit?
    # :nocov:
    update?
    # :nocov:
  end

  def destroy?
    admin_or_owns_resource?
  end

  def manage_access?
    # :nocov:
    user.has_global_admin_access?
    # :nocov:
  end

  def admin_or_owns_resource?
    return false if user.anonymous?

    return true if user.has_global_admin_access?

    # :nocov:
    if record.kind_of?(User)
      user == record
    elsif record.respond_to?(:user_id)
      record.user_id == user.id
    elsif record.respond_to?(:user)
      record.user == user
    else
      false
    end
    # :nocov:
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
    # :nocov:
    false
    # :nocov:
  end

  # @abstract
  def create_collections?
    # :nocov:
    false
    # :nocov:
  end

  # @abstract
  def create_items?
    # :nocov:
    false
    # :nocov:
  end

  # @!endgroup

  def has_any_access_management_permissions?
    user.can_manage_access_globally? || user.can_manage_access_contextually?
  end

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
    # :nocov:
    return true if admin_always_allowed && pundit_user.has_global_admin_access?

    return false if record.blank?

    policy_for(record, pundit_user:).public_send query
    # :nocov:
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
    # @return [void]
    def always_readable!
      always_readable true
    end

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
    # @return [ActiveRecord::Relation]
    attr_reader :scope

    # @return [AnonymousUser, User]
    attr_reader :user

    delegate :anonymous?, :has_global_admin_access?, :has_allowed_action?, to: :user

    # @param [User, AnonymousUser] user
    # @param [ActiveRecord::Relation] scope
    def initialize(user, scope)
      @user = user || AnonymousUser.new
      @scope = scope
    end

    # @abstract
    # @return [ActiveRecord::Relation]
    def resolve
      # :nocov:
      return scope.none if anonymous?

      scope.all
      # :nocov:
    end

    # @see #has_global_admin_access?
    # @see #has_allowed_action?
    # @param [String] name
    def admin_or_has_allowed_action?(name)
      has_global_admin_access? || has_allowed_action?(name)
    end
  end
end
