# frozen_string_literal: true

module Types
  module AccessGrantSubjectType
    include Types::BaseInterface

    description <<~TEXT
    An access grant subject is a person or group to which access for a specific entity
    (and all its children) has been granted.
    TEXT

    field :all_access_grants, resolver: Resolvers::AccessGrants::SubjectResolver,
      description: "A polymorphic connection for access grants from a subject"

    field :primary_role, Types::RoleType, null: true do
      description "The primary role associated with this subject."
    end

    field :assignable_roles, [Types::RoleType, { null: false }], null: false do
      description <<~TEXT
      The roles this user has access to assign based on their `primaryRole`,
      outside of any hierarchical context.

      When actually assigning roles for an entity, you should use `Entity.assignableRoles`,
      because it will ensure that the user sufficient permissions at that level.
      TEXT
    end

    # @return [Promise<Role>]
    def assignable_roles
      Support::Loaders::AssociationLoader.for(object.class, :assignable_roles).load(object)
    end

    # @return [Promise(Role), Promise(nil)]
    def primary_role
      Support::Loaders::AssociationLoader.for(object.class, :primary_role).load(object)
    end
  end
end
