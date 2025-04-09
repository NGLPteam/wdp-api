# frozen_string_literal: true

module Mutations
  module Contracts
    # Check the inputs for revoking access to an entity for a user.
    #
    # @see Access::Revoke
    # @see Mutations::Operations::RevokeAccess
    class RevokeAccess < MutationOperations::Contract
      json do
        required(:entity).filled(Support::GlobalTypes.Instance(HierarchicalEntity))
        required(:role).filled(Support::GlobalTypes.Instance(Role))
        required(:user).filled(Support::GlobalTypes.Instance(User))
      end

      rule(:entity, :role) do
        policy = Pundit.policy!(current_user, values[:entity])

        role = values[:role]

        key(:role_id).failure(:cannot_revoke_unassignable_role, role_name: role.name) unless policy.can_assign_role?(role)
      end

      rule(:user) do
        key(:$global).failure(:cannot_revoke_role_from_self) if value == current_user
      end
    end
  end
end
