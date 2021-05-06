# frozen_string_literal: true

# The configuration values for this class can be overridden
# with the following ENV values:
#
# - `KEYCLOAKADMIN_SERVER_URL`
# - `KEYCLOAKADMIN_SERVER_DOMAIN`
# - `KEYCLOAKADMIN_CLIENT_REALM_NAME`
# - `KEYCLOAKADMIN_CLIENT_ID`
# - `KEYCLOAKADMIN_CLIENT_SECRET`
class KeycloakAdminConfig < ApplicationConfig
  attr_config :server_url, :server_domain, :client_realm_name, :client_id, :client_secret

  required :server_url, :server_domain, :client_realm_name, :client_id, :client_secret
end
