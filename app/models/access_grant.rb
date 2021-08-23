# frozen_string_literal: true

class AccessGrant < ApplicationRecord
  include AssignsPolymorphicForeignKey
  include ScopesForUser

  belongs_to :accessible, polymorphic: true
  belongs_to :subject, polymorphic: true

  belongs_to :role, inverse_of: :access_grants

  belongs_to :community, optional: true
  belongs_to :collection, optional: true
  belongs_to :item, optional: true

  belongs_to :user_group, optional: true
  belongs_to :user, optional: true

  has_many :grouped_users, through: :user_group, source: :users
  has_many :permissions, through: :role

  scope :for_subject, ->(subject) { where(subject: subject) }
  scope :for_subject_type, ->(type) { where(subject_type: type) }

  assign_polymorphic_foreign_key! :accessible, :community, :collection, :item
  assign_polymorphic_foreign_key! :subject, :user, :user_group

  before_validation :sync_auth_path!

  after_save :calculate_granted_permissions!

  # @api private
  # @return [void]
  def sync_auth_path!
    self.auth_path = accessible.try(:auth_path)
  end

  # @api private
  # @return [void]
  def calculate_granted_permissions!
    WDPAPI::Container["access.calculate_granted_permissions"].call(access_grant: self)
  end

  class << self
    def for_user_group(user_group)
      user_group.present? ? where(user_group: user_group) : none
    end

    # @param [Role] role
    # @param [HierarchicalEntity] on
    # @param [AccessGrantSubject] to
    def has_granted?(role, on:, to:)
      exists?(role: role, accessible: on, subject: to)
    end

    # @param [HierarchicalEntity] accessible
    # @param [AccessGrantSubject] subject
    def fetch(accessible, subject)
      where(accessible: accessible, subject: subject).first_or_initialize
    end

    # @return [ActiveRecord::Relation<AccessGrant>]
    def matching_permissions(*patterns)
      inner_scope = unscoped.joins(:permissions).merge(Permission.contextual.matching(*patterns))

      where(id: inner_scope.select(:id))
    end

    # Uses an `ltree @> ltree` operation to check if the entity is contained by this access grant.
    #
    # @param [HierarchicalEntity, #auth_path] entity
    # @return [Arel::Nodes::InfixOperator]
    def arel_contains_entity(entity)
      arel_ltree_contains(arel_table[:auth_path], arel_cast(entity.auth_path, "ltree"))
    end

    # @return [ActiveRecord::Relation<AccessGrant>]
    def with_allowed_action(name:, entity:)
      joins(:role).where(arel_contains_entity(entity)).where(Role.arel_allowed_action(name))
    end

    def with_allowed_action?(**options)
      with_allowed_action(**options).exists?
    end

    # @return [ActiveRecord::Relation<AccessGrant>]
    def with_asset_creation
      matching_permissions "*.assets.create"
    end

    def with_asset_creation?
      with_asset_creation.exists?
    end
  end
end
