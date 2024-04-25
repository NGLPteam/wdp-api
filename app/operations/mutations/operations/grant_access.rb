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

      # @param [Role] role
      # @param [User] user
      # @param [HierarchicalEntity] entity
      # @return [void]
      def call(role:, user:, entity:)
        authorize entity, :manage_access?

        attempt = grant_access.call role, on: entity, to: user

        granted = attempt.success?

        attach! :entity, entity if granted
        attach! :granted, granted
      end
    end
  end
end
