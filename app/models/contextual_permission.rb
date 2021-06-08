# frozen_string_literal: true

class ContextualPermission < ApplicationRecord
  include ScopesForHierarchical
  include ScopesForUser
  include View

  # @todo Add composite-primary-keys
  self.primary_key = :hierarchical_id

  attribute :access_control_list, Roles::AccessControlList.to_type
  attribute :grid, Roles::EntityPermissionGrid.to_type

  belongs_to :hierarchical, polymorphic: true
  belongs_to :user

  delegate :permissions, to: :access_control_list

  # @see Loaders::ContextualPermissionLoader
  # @return [String]
  def loader_cache_key
    "#{hierarchical_type}:#{hierarchical_id}"
  end

  class << self
    # @param [User] user
    # @param [HierarchicalEntity] entity
    # @return [ContextualPermission, nil]
    def fetch(user, entity)
      return nil if user.blank? || user.anonymous?
      return nil unless entity.kind_of?(HierarchicalEntity)

      for_user(user).for_hierarchical(entity).first
    end
  end
end
