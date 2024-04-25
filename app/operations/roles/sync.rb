# frozen_string_literal: true

module Roles
  # Synchronize the database with the expected state for roles & permissions.
  #
  # * Synchronize the {Permissions::Sync permissions}
  # * Load the {Roles::LoadSystem system roles}.
  class Sync
    include Dry::Monads[:result, :do]
    include MeruAPI::Deps[
      sync_permissions: "permissions.sync",
      load_system: "roles.load_system"
    ]

    # @return [Dry::Monads::Result]
    def call
      yield sync_permissions.call

      role_ids = yield load_system.call

      Success(role_ids:)
    end
  end
end
