# frozen_string_literal: true

module PasswordFlow
  # Build an OIDC Client set up to authenticate against a password-flow client.
  class BuildClient
    # @return [OpenIDConnect::Client]
    def call
      OpenIDConnect::Client.new KeycloakPasswordFlowConfig.client_args
    end
  end
end
