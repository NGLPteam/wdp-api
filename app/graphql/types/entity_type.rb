# frozen_string_literal: true

module Types
  module EntityType
    include Types::BaseInterface
    include Types::ExposesPermissionsType

    description "An entity that exists in the hierarchy."

    field :access_control_list, Types::AccessControlListType, null: true do
      description "Derived access control list"
    end

    field :applicable_roles, [Types::RoleType], null: true do
      description "The role(s) that gave the permissions to access this resource, if any."
    end

    # @return [Promise(ContextualPermission)]
    def contextual_permission
      Loaders::ContextualPermissionLoader.for(context[:current_user]).load(object)
    end

    # @return [Promise(Roles::AccessControlList)]
    def access_control_list
      contextual_permission.then do |permission|
        permission&.access_control_list || Roles::AccessControlList.new
      end
    end

    def allowed_actions
      contextual_permission.then do |permission|
        permission&.allowed_actions || []
      end
    end

    # @return [Promise(<Role>)]
    def applicable_roles
      contextual_permission.then do |permission|
        next [] if permission.blank? || permission.role_ids.blank?

        Loaders::RecordLoader.for(::Role).load_many(permission.role_ids)
      end
    end

    def permissions
      contextual_permission.then do |permission|
        next [] if permission.blank?

        permission.permissions
      end
    end
  end
end
