# frozen_string_literal: true

class Role < ApplicationRecord
  include HasSystemSlug

  has_many :access_grants, dependent: :destroy, inverse_of: :role

  has_many :community_memberships, dependent: :destroy, inverse_of: :role

  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :contextually_assigned_roles, inverse_of: :role
  # rubocop:enable Rails/HasManyOrHasOneDependent

  has_many :role_permissions, dependent: :destroy, inverse_of: :role

  has_many :permissions, through: :role_permissions

  attribute :access_control_list, Roles::AccessControlList.to_type

  before_validation :calculate_allowed_actions!

  after_save :calculate_role_permissions!

  scope :for_name, ->(name) { where(name: name) }

  scope :with_allowed_action, ->(name) { where(arel_allowed_action(name)) }

  validates :name, presence: true, uniqueness: true

  # @api private
  # @return [void]
  def calculate_allowed_actions!
    self.allowed_actions = access_control_list.calculate_allowed_actions
  end

  # @api private
  # @return [void]
  def calculate_role_permissions!
    call_operation "roles.calculate_role_permissions", role: self
  end

  # @return [void]
  def recalculate_granted_permissions!
    Access::CalculateRoleGrantedPermissionsJob.perform_later self
  end

  class << self
    def fetch(name)
      where(name: name).first!
    end

    def arel_allowed_action(name)
      arel_ltree_contains(arel_table[:allowed_actions], arel_cast(name, "ltree"))
    end
  end
end
