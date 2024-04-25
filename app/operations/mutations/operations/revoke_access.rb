# frozen_string_literal: true

module Mutations
  module Operations
    # @see Access::Revoke
    # @see Mutations::RevokeAccess
    # @see Mutations::Contracts::RevokeAccess
    class RevokeAccess
      include MutationOperations::Base
      include MeruAPI::Deps[revoke_access: "access.revoke"]

      use_contract! :revoke_access

      # @param [Role] role
      # @param [User] user
      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(role:, user:, entity:)
        authorize entity, :manage_access?

        attempt = revoke_access.call role, on: entity, to: user

        revoked = attempt.success?

        attach! :entity, entity if revoked
        attach! :revoked, revoked
      end
    end
  end
end
