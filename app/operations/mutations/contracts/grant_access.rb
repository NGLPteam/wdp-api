# frozen_string_literal: true

module Mutations
  module Contracts
    # Check the inputs for granting access to an entity for a user.
    class GrantAccess < MutationOperations::Contract
      json do
        required(:user).filled(AppTypes.Instance(User))
      end

      rule(:user) do
        key(:$global).failure("You cannot assign a role to yourself") if value == current_user
      end
    end
  end
end
