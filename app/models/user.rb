# frozen_string_literal: true

class User < ApplicationRecord
  validates :keycloak_id, presence: true

  scope :global_admins, -> { where(arel_has_role(:admin)) }

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

  class << self
    def arel_has_role(name)
      Arel::Nodes.build_quoted(name).eq(Arel::Nodes::NamedFunction.new("ANY", [arel_table[:roles]]))
    end
  end
end
