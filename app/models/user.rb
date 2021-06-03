# frozen_string_literal: true

class User < ApplicationRecord
  include HasSystemSlug

  has_many :access_grants, dependent: :destroy, inverse_of: :user

  has_many :community_memberships, dependent: :destroy, inverse_of: :user

  has_many :communities, through: :community_memberships

  validates :keycloak_id, presence: true

  scope :global_admins, -> { where(arel_has_role(:admin)) }
  scope :testing, -> { where_contains(email: "@example.") }

  def anonymous?
    false
  end

  def authenticated?
    true
  end

  def has_role?(name)
    name.to_s.in? roles
  end

  def has_global_admin_access?
    has_role? :global_admin
  end

  def system_slug_id
    keycloak_id
  end

  class << self
    def arel_has_role(name)
      Arel::Nodes.build_quoted(name).eq(Arel::Nodes::NamedFunction.new("ANY", [arel_table[:roles]]))
    end
  end
end
