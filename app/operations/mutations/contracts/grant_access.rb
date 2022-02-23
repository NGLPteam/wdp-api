# frozen_string_literal: true

module Mutations
  module Contracts
    # Check the inputs for granting access to an entity for a user.
    class GrantAccess < MutationOperations::Contract
      json do
        required(:entity).filled(AppTypes.Instance(HierarchicalEntity))
        required(:role).filled(AppTypes.Instance(Role))
        required(:user).filled(AppTypes.Instance(User))
      end

      rule(:entity, :role) do
        policy = Pundit.policy!(current_user, values[:entity])

        unless policy.manage_access?
          key(:$global).failure(:cannot_grant_role_on_entity)

          next
        end

        role = values[:role]

        key(:role_id).failure(:cannot_grant_unassignable_role, role_name: role.name) unless policy.can_assign_role?(role)
      end

      rule(:user) do
        key(:$global).failure(:cannot_grant_role_to_self) if value == current_user
      end
    end
  end
end
