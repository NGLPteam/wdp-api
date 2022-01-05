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
    include WDPAPI::Deps[transform_token: "users.transform_token"]

    # @param [Hash] env a Rack environment, generally acquired from `request.env`
    # @return [Dry::Monads::Result]
    def call(env)
      env["keycloak:session"].authenticate! do |m|
        m.success(:authenticated) do |_, token|
          attributes = transform_token.call(token)

          result = ::User.upsert attributes, returning: %w[id], unique_by: %w[keycloak_id]

          user_id = result.first["id"]

          user = User.find user_id

          # TODO: Remove after GACL is controlled more specifically
          user.global_access_control_list = Roles::GlobalAccessControlList.build_with(true)

          user.save!

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
