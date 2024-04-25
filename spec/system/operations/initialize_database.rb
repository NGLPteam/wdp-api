# frozen_string_literal: true

module Testing
  # This is used to prepare the test database with certain records
  # that should always exist in the API. Override as necessary
  class InitializeDatabase
    include Dry::Monads[:do, :result]

    include Common::Deps[
      reload_everything: "system.reload_everything",
    ]

    def call
      yield reload_everything.call

      Success nil
    end
  end
end
