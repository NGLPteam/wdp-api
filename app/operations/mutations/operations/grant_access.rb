# frozen_string_literal: true

module Mutations
  module Operations
    class GrantAccess
      include MutationOperations::Base
      include WDPAPI::Deps[grant_access: "access.grant"]

      def call(role:, user:, entity:)
        authorize entity, :manage_access?

        attempt = grant_access.call role, on: entity, to: user

        granted = attempt.success?

        attach! :entity, entity if granted
        attach! :granted, granted
      end

      def validate!(user:, **args)
        add_error! "You cannot grant a role to yourself.", path: "user" if user == current_user
      end
    end
  end
end
