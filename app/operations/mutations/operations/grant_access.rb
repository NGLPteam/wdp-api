# frozen_string_literal: true

module Mutations
  module Operations
    class GrantAccess
      include MutationOperations::Base
      include WDPAPI::Deps[grant_access: "access.grant"]

      use_contract! :grant_access

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
