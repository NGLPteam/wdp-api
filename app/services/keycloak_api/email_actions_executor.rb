# frozen_string_literal: true

module KeycloakAPI
  # @see KeycloakAPI::ExecuteActionsEmail
  class EmailActionsExecutor < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :user_id, KeycloakAPI::Types::KeycloakID

      param :actions, KeycloakAPI::Types::EmailActions

      option :client_id, KeycloakAPI::Types::ClientID.optional, optional: true

      option :lifespan, KeycloakAPI::Types::Lifespan, default: proc { 1.hour }

      option :redirect_uri, KeycloakAPI::Types::RedirectURI.optional, optional: true
    end

    include MeruAPI::Deps[keycloak_realm: "keycloak.realm"]

    standard_execution!

    # @return [KeycloakAdmin::UserClient]
    attr_reader :users

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield request_email_action!
      end

      Success()
    end

    wrapped_hook! def prepare
      @users = keycloak_realm.users

      super
    end

    wrapped_hook! def request_email_action
      users.execute_actions_email(user_id, actions, lifespan, redirect_uri, client_id)

      super
    rescue RuntimeError => e
      Failure[:request_failed, e.message]
    end
  end
end
