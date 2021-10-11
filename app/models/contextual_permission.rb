# frozen_string_literal: true

# Similar to {ContextualSinglePermission}, this view is used to calculate what {Permission}s,
# if any, a {User} can perform on an {Entity}. It is highly optimized for selective querying
# and should not be called to fetch every possible user/entity/permission combination.
class ContextualPermission < ApplicationRecord
  include ScopesForHierarchical
  include ScopesForUser
  include View

  DEFAULT_ATTRIBUTES = {
    has_any_role: false,
    has_direct_role: false,
    access_grant_ids: [],
    role_ids: [],
    allowed_actions: [],
    access_control_list: {},
    grid: {}
  }.freeze

  self.primary_key = [:user_id, :hierarchical_type, :hierarchical_id]

  attribute :access_control_list, Roles::AccessControlList.to_type, default: {}
  attribute :grid, Roles::EntityPermissionGrid.to_type, default: {}

  belongs_to :hierarchical, polymorphic: true
  belongs_to :user

  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :contextually_assigned_roles, primary_key: primary_key, foreign_key: primary_key, inverse_of: :contextual_permission
  # rubocop:enable Rails/HasManyOrHasOneDependent

  has_many :roles, through: :contextually_assigned_roles

  delegate :permissions, to: :access_control_list

  # @see Loaders::ContextualPermissionLoader
  # @return [String]
  def loader_cache_key
    "#{hierarchical_type}:#{hierarchical_id}"
  end

  class << self
    # If a match cannot be found for the provided combination,
    # {#empty_permission_for an empty result} will be provided.
    #
    # @param [User] user
    # @param [HierarchicalEntity] entity
    # @return [ContextualPermission]
    def fetch(user, entity)
      return nil if user.blank? || user.anonymous?
      return nil unless entity.kind_of?(HierarchicalEntity)

      for_user(user).for_hierarchical(entity).first || empty_permission_for(user, entity)
    end

    # Calculate an empty permission set for a given user / entity combination.
    #
    # @param [User] user
    # @param [HierarchicalEntity] entity
    # @return [ContextualPermission]
    def empty_permission_for(user, entity)
      attrs = DEFAULT_ATTRIBUTES.merge(
        hierarchical: entity,
        user: user
      )

      ContextualPermission.new(attrs)
    end

    # @param [<String>] actions
    # @return [ActiveRecord::Relation<ContextualPermission>]
    def with_actions(*actions)
      actions.flatten!

      allowed_actions = arel_table[:allowed_actions]

      return none if actions.blank?

      expr = arel_or_expressions(actions) do |action|
        arel_ltree_contains(allowed_actions, arel_ltree(action))
      end

      where expr
    end

    # @param [AnonymousUser, User] user
    # @param [<String>] actions
    # @return [ActiveRecord::Relation<ContextualPermission>]
    def with_permitted_actions_for(user, *actions)
      for_user(user).with_actions(*actions)
    end
  end
end
