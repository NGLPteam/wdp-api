# frozen_string_literal: true

module PasswordFlow
  # Build an OAuth2 Client set up to authenticate against a password-flow client.
  class GetToken
    include MeruAPI::Deps[build_client: "password_flow.build_client"]

    # @param [String] username
    # @param [String] password
    # @param [:admin, nil] client_id
    # @return [OpenIDConnect::AccessToken]
    def call(username, password, client_id: nil, via_admin: false)
      if via_admin
        admin_client = client_from client_id: :admin

        admin_client.resource_owner_credentials = [username, password]

        admin_token = token_from admin_client

        exchange_client = client_from client_id: nil

        exchange_client.subject_token = admin_token.access_token

        token_from exchange_client
      else
        client = client_from(client_id:)

        client.resource_owner_credentials = [username, password]

        token_from client
      end
    end

    private

    def client_from(client_id: nil, via_admin: false)
      options = {}

      options[:client_id] = via_admin ? :admin : client_id

      build_client.call options
    end

    def token_from(client)
      client.access_token! scope: "openid profile email"
    end
  end
end
