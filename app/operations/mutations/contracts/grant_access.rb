# frozen_string_literal: true

module Mutations
  module Contracts
    # Check the inputs for granting access to an entity for a user.
    class GrantAccess < MutationOperations::Contract
      json do
        required(:entity).filled(Support::GlobalTypes.Instance(HierarchicalEntity))
        required(:role).filled(Support::GlobalTypes.Instance(Role))
        required(:user).filled(Support::GlobalTypes.Instance(User))
      end

      rule(:entity, :role) do
        policy = Pundit.policy!(current_user, values[:entity])

        role = values[:role]

        key(:role_id).failure(:cannot_grant_unassignable_role, role_name: role.name) unless policy.can_assign_role?(role)
      end

      rule(:user) do
        key(:$global).failure(:cannot_grant_role_to_self) if value == current_user
      end
    end
  end
end
