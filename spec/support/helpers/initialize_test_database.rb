# frozen_string_literal: true

module Testing
  # This is used to prepare the test database with certain records
  # that should always exist in a running instance of WDP-API.
  class InitializeTestDatabase
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[permission_sync: "permissions.sync"]

    def call
      yield permission_sync.call

      Success nil
    end

    class << self
      def call
        new.call
      end
    end
  end
end
