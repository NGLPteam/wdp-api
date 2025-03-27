# frozen_string_literal: true

module Resolvers
  # @see ::Types::EntityPermissionFilterType
  module FiltersByEntityPermission
    extend ActiveSupport::Concern

    included do
      option :access, type: ::Types::EntityPermissionFilterType, default: "SKIP", replace_null_with_default: true
    end

    # @param [ActiveRecord::Relation<HierarchicalEntity>]
    def apply_access_with_skip(scope)
      scope.all
    end

    # @see HierarchicalEntity::ClassMethods#readable_by
    # @param [ActiveRecord::Relation<HierarchicalEntity>]
    def apply_access_with_read_only(scope)
      scope.readable_by(relative_user)
    end

    # @see HierarchicalEntity::ClassMethods#updatable_by
    # @param [ActiveRecord::Relation<HierarchicalEntity>]
    def apply_access_with_update(scope)
      scope.updatable_by(relative_user)
    end
  end
end
