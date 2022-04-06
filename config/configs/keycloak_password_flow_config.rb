# frozen_string_literal: true

class KeycloakPasswordFlowConfig < ApplicationConfig
  include Dry::Core::Memoizable

  attr_config :realm_id
  attr_config :client_id
  attr_config :client_secret

  attr_config :admin_realm_id
  attr_config :admin_client_id
  attr_config :admin_client_secret

  def client_args_for(id)
    case id
    when /admin/ then admin_client_args
    else
      client_args
    end
  end

  # @return [Hash]
  memoize def client_args
    build_client_args realm_id, client_id, client_secret
  end

  memoize def admin_client_args
    build_client_args admin_realm_id, admin_client_id, admin_client_secret
  end

  memoize def keycloak_config
    KeycloakRack::Config.new
  end

  memoize def keycloak_url
    URI.parse keycloak_config.server_url
  end

  private

  # @param [String] realm_id
  # @param [String] client_id
  # @param [String] client_secret
  # @return [Hash]
  def build_client_args(realm_id, client_id, client_secret)
    oidc_config = oidc_config_for realm_id

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

  # @param [String] realm_id
  # @return [String]
  def issuer_for(realm_id)
    "#{keycloak_config.server_url}/realms/#{realm_id}"
  end

  # @param [String] realm_id
  # @return [OpenIDConnect::Discovery::Provider::Config::Response]
  def oidc_config_for(realm_id)
    issuer = issuer_for realm_id

    OpenIDConnect::Discovery::Provider::Config.discover! issuer
  end
end
