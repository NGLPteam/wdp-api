# frozen_string_literal: true

Dry::Rails.container do
  config.features = %i[application_contract safe_params controller_helpers]

  auto_register! "app/operations"

  register :filesystem, memoize: !Rails.env.test? do
    Dry::Files.new memory: Rails.env.test?
  end

  namespace :keycloak do
    register :config, memoize: true do
      KeycloakRack::Config.new
    end

    register :realm_id, memoize: true do
      resolve("config").realm_id
    end

    register :realm do
      KeycloakAdmin.realm(resolve("realm_id"))
    end

    register :roles, memoize: true do
      resolve("realm").roles.list
    end
  end

  register :hashids, memoize: true do
    Hashids.new SecurityConfig.hash_salt
  end

  register :node_verifier, memoize: true do
    ActiveSupport::MessageVerifier.new SecurityConfig.node_salt, digest: "SHA256"
  end
end
