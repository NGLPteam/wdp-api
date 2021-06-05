# frozen_string_literal: true

module Mutations
  module Operations
    class RevokeAccess
      include MutationOperations::Base
      include WDPAPI::Deps[revoke_access: "access.revoke"]

      def call(role:, user:, entity:)
        authorize entity, :manage_access?

        attempt = revoke_access.call role, on: entity, to: user

        revokeed = attempt.success?

        attach! :entity, entity if revokeed
        attach! :revoked, revokeed
      end

      def validate!(user:, **args)
        add_error! "You cannot revoke a role from yourself.", path: "user" if user == current_user
      end
    end
  end
end
