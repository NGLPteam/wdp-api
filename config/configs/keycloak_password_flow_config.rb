# frozen_string_literal: true

class KeycloakPasswordFlowConfig < ApplicationConfig
  include Dry::Core::Memoizable

  attr_config :client_id
  attr_config :client_secret

  # @return [Hash]
  memoize def client_args
    {
      identifier: client_id,
      secret: client_secret,
      host: keycloak_url.host,
      scheme: keycloak_url.scheme,
      scopes_supported: oidc_config.scopes_supported,
      authorization_endpoint: oidc_config.authorization_endpoint,
      token_endpoint: oidc_config.token_endpoint,
      userinfo_endpoint: oidc_config.userinfo_endpoint,
      jwks_uri: oidc_config.jwks_uri,
    }
  end

  memoize def keycloak_config
    KeycloakRack::Config.new
  end

  memoize def keycloak_url
    URI.parse keycloak_config.server_url
  end

  memoize def issuer
    "#{keycloak_config.server_url}/realms/#{keycloak_config.realm_id}"
  end

  memoize def oidc_config
    OpenIDConnect::Discovery::Provider::Config.discover! issuer
  end
end
