# frozen_string_literal: true

module Users
  # Using [keycloak_rack](https://github.com/scryptmouse/keycloak_rack/), authenticate
  # a user session and either upsert a {User} with values from the decoded token,
  # set up the session as an {AnonymousUser}, or pass along any token failures for
  # handling elsewhere.
  #
  # @see ApplicationController#authenticate_user!
  # @see Users::TransformToken
  # @subsystem Authentication
  class Authenticate
    include Dry::Monads[:result]
    include MeruAPI::Deps[
      upsert_from_token: "users.upsert_from_token",
    ]

    # @param [Hash] env a Rack environment, generally acquired from `request.env`
    # @return [Dry::Monads::Result]
    def call(env)
      env["keycloak:session"].authenticate! do |m|
        m.success(:authenticated) do |_, token|
          upsert_from_token.(token)
        end

        m.success do
          Success AnonymousUser.new
        end

        m.failure do |code, reason|
          Failure[code, reason]
        end
      end
    end
  end
end
