# frozen_string_literal: true

class Role < ApplicationRecord
  include HasEphemeralSystemSlug
  include TimestampScopes

  pg_enum! :identifier, as: "role_identifier", prefix: :identified_as
  pg_enum! :kind, as: "role_kind", prefix: :for
  pg_enum! :primacy, as: "role_primacy", prefix: :has, suffix: :primacy

  attr_readonly :identifier, :primacy, :kind, :priority, :allowed_actions, :global_allowed_actions

  has_many :access_grants, dependent: :destroy, inverse_of: :role

  has_many_readonly :assignable_role_targets, -> { in_order }, foreign_key: :source_role_id, inverse_of: :source_role
  has_many_readonly :assignable_roles, through: :assignable_role_targets, source: :target_role
  has_many_readonly :assignable_role_sources, class_name: "AssignableRoleTarget", foreign_key: :target_role_id, inverse_of: :target_role

  has_many :community_memberships, dependent: :destroy, inverse_of: :role

  has_many_readonly :contextually_assigned_roles, inverse_of: :role

  has_many_readonly :primary_role_assignments, inverse_of: :role

  has_many_readonly :primarily_assigned_users, through: :primary_role_assignments, source: :user

  has_many :role_permissions, dependent: :destroy, inverse_of: :role

  has_many :permissions, through: :role_permissions

  attribute :access_control_list, Roles::AccessControlList.to_type
  attribute :global_access_control_list, Roles::GlobalAccessControlList.to_type

  after_save :calculate_role_permissions!

  scope :for_identifier, ->(identifier) { where(identifier:) }
  scope :for_name, ->(name) { where(name:) }

  scope :with_allowed_action, ->(name) { where(arel_allowed_action(name)) }
  scope :in_default_order, -> { order(primacy: :asc, priority: :desc, kind: :asc) }

  validates :name, presence: true, uniqueness: true

  validates :custom_priority, presence: { if: :for_custom? }

  # @api private
  # @see Roles::CalculateRolePermissions
  # @return [void]
  def calculate_role_permissions!
    call_operation "roles.calculate_role_permissions", role: self
  end

  # @see Roles::CalculateRoleGrantedPermissionsJob
  # @return [void]
  def recalculate_granted_permissions!
    Access::CalculateRoleGrantedPermissionsJob.perform_later self
  end

  # @see AssignableRoleTarget
  # @return [void]
  def refresh_assignable_role_targets!
    AssignableRoleTarget.refresh!
  end

  def to_upsert
    attrs = slice(:identifier, :name, :custom_priority, :access_control_list, :global_access_control_list).symbolize_keys

    unique_by = attrs[:identifier].present? ? %i[identifier] : %i[name]

    [attrs, unique_by]
  end

  class << self
    # @param [#to_s] identifier
    # @return [Role]
    def fetch(identifier)
      for_identifier(identifier).first!
    end

    def arel_allowed_action(name)
      arel_ltree_contains(arel_table[:allowed_actions], arel_cast(name, "ltree"))
    end
  end
end
