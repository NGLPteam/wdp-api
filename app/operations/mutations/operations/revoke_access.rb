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

      authorizes! :entity, with: :manage_access?

      # @param [Role] role
      # @param [User] user
      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(role:, user:, entity:, provisional_access_grant:)
        # Fallback _after_ validation to sanity-check the grant.
        authorize provisional_access_grant, :destroy?

        attempt = revoke_access.call role, on: entity, to: user

        revoked = attempt.success?

        attach! :entity, entity if revoked
        attach! :revoked, revoked
      end

      # @return [void]
      before_prepare def prepare_provisional_access_grant!
        args => { role:, user: subject, entity: accessible, }

        args[:provisional_access_grant] = AccessGrant.new(role:, subject:, accessible:)
      end
    end
  end
end
