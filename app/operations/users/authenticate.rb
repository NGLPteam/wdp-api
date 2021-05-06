# frozen_string_literal: true

module Users
  class Authenticate
    include Dry::Monads[:result]
    include WDPAPI::Deps[transform_token: "users.transform_token"]

    def call(env)
      env["keycloak:session"].authenticate! do |m|
        m.success(:authenticated) do |_, token|
          attributes = transform_token.call(token)

          result = ::User.upsert attributes, returning: %w[id], unique_by: %w[keycloak_id]

          user_id = result.first["id"]

          user = User.find user_id

          Success user
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
