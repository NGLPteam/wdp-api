# frozen_string_literal: true

module PasswordFlow
  # Build an OAuth2 Client set up to authenticate against a password-flow client.
  class GetToken
    include WDPAPI::Deps[build_client: "password_flow.build_client"]

    # @param [String] username
    # @param [String] password
    # @return [OpenIDConnect::AccessToken]
    def call(username, password)
      client = build_client.call

      client.resource_owner_credentials = [username, password]

      client.access_token! scope: "openid profile email"
    end
  end
end
