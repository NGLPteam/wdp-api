# frozen_string_literal: true

module Testing
  module Keycloak
    class Application < Sinatra::Base
      configure do
        disable :protection

        set :environment, "test"
        set :quiet, true
        set :sessions, false

        krc = ::KeycloakRack::Config.new

        set :keycloak_rack_config, krc

        set :kc_server_url, krc.server_url
        set :realm_id, krc.realm_id

        set :global_registry, Testing::Keycloak::GlobalRegistry.instance

        set :tokens, ::Testing::Tokens::Context.new
      end

      get ?/ do
        json info: "Test Keycloak"
      end

      put "/admin/realms/:realm_name/users/:user_id/execute-actions-email" do
        if settings.global_registry.users.exists?(params[:user_id])
          json params[:user_id]
        else
          pass
        end
      end

      get "/realms/:realm_name/protocol/openid-connect/certs" do
        json settings.tokens.jwks
      end

      post "/realms/:realm_name/protocol/openid-connect/token" do
        cache_control :no_store

        access_token = "123456"
        token_type = "Bearer"

        json access_token:, token_type:
      end

      not_found do
        json message: "Not Found"
      end

      class << self
        # @note Can't use `Singleton` because sinatra dups itself.
        def instance
          @instance ||= new
        end
      end
    end
  end
end
