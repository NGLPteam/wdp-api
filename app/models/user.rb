# frozen_string_literal: true

class User < ApplicationRecord
  include AccessGrantSubject
  include HasSystemSlug
  include ImageUploader::Attachment.new(:avatar)

  has_many :community_memberships, dependent: :destroy, inverse_of: :user

  has_many :communities, through: :community_memberships

  has_many :user_group_memberships, dependent: :destroy, inverse_of: :user

  has_many :user_groups, through: :user_group_memberships

  validates :keycloak_id, presence: true

  attribute :global_access_control_list, Roles::GlobalAccessControlList.to_type

  before_validation :set_allowed_actions!

  after_create :assign_global_permissions!

  scope :global_admins, -> { where(arel_has_realm_role(:global_admin)) }
  scope :testing, -> { where_contains(email: "@example.") }
  scope :by_role_priority, -> { order(role_priority: :desc) }
  scope :by_inverse_role_priority, -> { order(role_priority: :asc) }

  scope :recent, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :with_name_ascending, -> { order(name: :asc) }
  scope :with_name_descending, -> { order(name: :desc) }
  scope :with_email_ascending, -> { order(email: :asc) }
  scope :with_email_descending, -> { order(email: :desc) }

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

  def testing?
    /@example\./.match?(email) || metadata["testing"]
  end

  def normalize_testing!
    call_operation("users.normalize_testing", self)
  end

  def sync_testing!
    call_operation("users.sync_testing", self)
  end

  def to_whoami
    {
      anonymous: false,
      name: name
    }
  end

  # @!attribute [r] upload_token
  # @return [String]
  def upload_token
    call_operation("uploads.encode_token", self).value_or(nil)
  end

  class << self
    # @param [String] input
    # @return [ActiveRecord::Relation]
    def apply_prefix(input)
      needle = WDPAPI::Container["searching.prefix_sanitize"].(input)

      return all if needle.blank?

      where_begins_like(
        search_given_name: needle,
        search_family_name: needle,
        _or: true,
        _case_sensitive: true
      )
    end

    # Scope users that have *all* allowed actions matching the provided input.
    #
    # @param [<String>] actions
    # @return [ActiveRecord::Relation<User>]
    def with_all_allowed_actions(*actions)
      actions.flatten.reduce(all) do |scope, action|
        scope.with_allowed_actions(action)
      end
    end

    # Scope users that have *any* allowed actions matching the provided input.
    #
    # @param [<String>] actions
    # @return [ActiveRecord::Relation<User>]
    def with_allowed_actions(*actions)
      actions.flatten!

      where(arel_ltree_matches_one_or_any(arel_table[:allowed_actions], actions))
    end

    # Check if the user has a string "realm" role from Keycloak.
    #
    # @api private
    # @return [Arel::Nodes::Equality]
    def arel_has_realm_role(name)
      arel_quote(name).eq(arel_named_fn("ANY", arel_table[:roles]))
    end
  end
end
