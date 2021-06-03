# frozen_string_literal: true

class ComposedPermission < ApplicationRecord
  include ScopesForHierarchical
  include ScopesForUser
  include View

  attribute :grid, Roles::PermissionGrid.to_type

  belongs_to :hierarchical, polymorphic: true, optional: false
  belongs_to :user, optional: false

  class << self
    # @param [User] user
    # @param [HierarchicalEntity] hierarchical
    # @return [ComposedPermission]
    def fetch(user, hierarchical)
      for_hierarchical(hierarchical).for_user(user).first
    end
  end
end
