# frozen_string_literal: true

module Testing
  # This is used to prepare the test database with certain records
  # that should always exist in a running instance of WDP-API.
  class InitializeTestDatabase
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      role_sync: "roles.sync",
      load_static_schemas: "schemas.static.load_definitions"
    ]

    def call
      yield role_sync.call
      yield load_static_schemas.call

      Success nil
    end

    class << self
      def call
        new.call
      end
    end
  end
end
