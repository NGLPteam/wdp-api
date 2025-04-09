# frozen_string_literal: true

module Mutations
  module Operations
    # @see Access::Grant
    # @see Mutations::GrantAccess
    # @see Mutations::Contracts::GrantAccess
    class GrantAccess
      include MutationOperations::Base
      include MeruAPI::Deps[grant_access: "access.grant"]

      use_contract! :grant_access

      authorizes! :entity, with: :manage_access?

      # @param [Role] role
      # @param [User] user
      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(role:, user:, entity:, provisional_access_grant:)
        # Fallback _after_ validation to sanity-check the grant.
        authorize provisional_access_grant, :create?

        attempt = grant_access.call role, on: entity, to: user

        granted = attempt.success?

        attach! :entity, entity if granted
        attach! :granted, granted
      end

      # @return [void]
      before_prepare def prepare_provisional_access_grant!
        args => { role:, user: subject, entity: accessible, }

        args[:provisional_access_grant] = AccessGrant.new(role:, subject:, accessible:)
      end
    end
  end
end
