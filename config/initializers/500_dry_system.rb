# frozen_string_literal: true

Dry::Rails.container do
  config.features = %i[application_contract safe_params controller_helpers]

  config.component_dirs.add "app/operations"

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

  namespace :hacks do
    register :ucm_units, memoize: true do
      JSON.parse(Rails.root.join("vendor/ucm/ucm_units.json").read).pluck("id").sort.uniq.sort_by do |unit|
        [unit.size, unit]
      end.reverse
    end
  end
end
