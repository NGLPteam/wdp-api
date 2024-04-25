# frozen_string_literal: true

KeycloakRack.configure do |config|
  config.skip_paths = {
    get: [?/, "/ping"],
  }
end

KeycloakAdmin.configure do |config|
  config.use_service_account = true

  config.server_url = KeycloakAdminConfig.server_url
  config.server_domain = KeycloakAdminConfig.server_domain
  config.client_realm_name = KeycloakAdminConfig.client_realm_name
  config.client_id = KeycloakAdminConfig.client_id
  config.client_secret = KeycloakAdminConfig.client_secret
end

module Patches
  module RoleMapperExtensions
    def available_url
      "#{realm_level_url}/available"
    end

    def available
      response = execute_http do
        RestClient::Resource.new(available_url, @configuration.rest_client_options).get(headers)
      end

      JSON.parse(response).map { |role_as_hash| KeycloakAdmin::RoleRepresentation.from_hash(role_as_hash) }
    end

    def list
      response = execute_http do
        RestClient::Resource.new(realm_level_url, @configuration.rest_client_options).get(headers)
      end

      JSON.parse(response).map { |role_as_hash| KeycloakAdmin::RoleRepresentation.from_hash(role_as_hash) }
    end

    def remove(role_representation_list)
      execute_http do
        RestClient::Request.execute(method: :delete, url: realm_level_url, payload: role_representation_list.to_json, headers:)
      end
    end
  end

  module RemoveClientRole
    def as_json(...)
      super.without("client_role")
    end
  end
end

KeycloakAdmin::RoleMapperClient.prepend Patches::RoleMapperExtensions
KeycloakAdmin::RoleRepresentation.prepend Patches::RemoveClientRole
