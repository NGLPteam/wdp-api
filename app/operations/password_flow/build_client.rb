# frozen_string_literal: true

module PasswordFlow
  # Build an OIDC Client set up to authenticate against a password-flow client.
  class BuildClient
    # @return [OpenIDConnect::Client]
    def call(client_id: nil)
      OpenIDConnect::Client.new KeycloakPasswordFlowConfig.client_args_for client_id
    end
  end
end
