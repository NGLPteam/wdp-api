# frozen_string_literal: true

# Scopes and other helpers for checking on permissions for a {HierarchicalEntity},
# {Entity}, or {EntityAdjacent}.
#
# @see ContextualSinglePermission
module ChecksContextualPermissions
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :contextual_permission_primary_key, type: Entities::Types::Symbol

    contextual_permission_primary_key :_must_be_set
  end

  module ClassMethods
    # @see .with_permitted_actions_for
    # @see Resolvers::FiltersByEntityPermission#apply_access_with_read_only
    # @note This is specifically for checking for permissions to read the entire entity,
    #   not necessarily whether or not the entity can be shown in the FE, etc.
    # @param [User] user
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def readable_by(user)
      # :nocov:
      return all if user.try(:has_global_admin_access?)
      # :nocov:

      with_permitted_actions_for(user, "self.read")
    end

    # @see .with_permitted_actions_for
    # @see Resolvers::FiltersByEntityPermission#apply_access_with_update
    # @param [User] user
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def updatable_by(user)
      # :nocov:
      return all if user.try(:has_global_admin_access?)
      # :nocov:

      with_permitted_actions_for(user, "self.update")
    end

    # @param [User] user
    # @param [<String>] actions
    # @return [ActiveRecord::Relation<HierarchicalEntity>]
    def with_permitted_actions_for(user, *actions)
      constraint = ContextualSinglePermission.for_hierarchical_type(model_name.to_s).with_permitted_actions_for(user, *actions).select(:hierarchical_id)

      where(contextual_permission_primary_key => constraint)
    end
  end
end
