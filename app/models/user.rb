# frozen_string_literal: true

class User < ApplicationRecord
  include AccessGrantSubject
  include HasSystemSlug

  has_many :community_memberships, dependent: :destroy, inverse_of: :user

  has_many :communities, through: :community_memberships

  has_many :user_group_memberships, dependent: :destroy, inverse_of: :user

  has_many :user_groups, through: :user_group_memberships

  validates :keycloak_id, presence: true

  attribute :global_access_control_list, Roles::GlobalAccessControlList.to_type

  before_validation :set_allowed_actions!

  scope :global_admins, -> { where(arel_has_role(:global_admin)) }
  scope :testing, -> { where_contains(email: "@example.") }

  delegate :permissions, to: :global_access_control_list

  def anonymous?
    false
  end

  def authenticated?
    true
  end

  # @param [HierarchicalEntity] entity
  # @return [ContextualPermission, nil]
  def contextual_permissions_for(entity)
    ContextualPermission.fetch(self, entity)
  end

  def has_allowed_action?(name)
    name.to_s.in?(allowed_actions)
  end

  def has_role?(name)
    name.to_s.in? roles
  end

  def has_global_admin_access?
    has_role? :global_admin
  end

  def has_any_upload_access?
    has_global_admin_access? || has_granted_asset_creation?
  end

  def system_slug_id
    keycloak_id
  end

  # @!scope private
  # @return [void]
  def set_allowed_actions!
    self.allowed_actions = global_access_control_list.allowed_actions
  end

  class << self
    def arel_has_role(name)
      Arel::Nodes.build_quoted(name).eq(Arel::Nodes::NamedFunction.new("ANY", [arel_table[:roles]]))
    end
  end
end
