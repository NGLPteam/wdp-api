# frozen_string_literal: true

module Users
  class TransformToken
    # @param [Keycloak::DecodedToken]
    def call(token)
      token.slice(:keycloak_id, :email, :email_verified, :given_name, :family_name, :name).tap do |h|
        h[:username] = token.preferred_username
        h[:roles] = token.realm_access.roles
        h[:resource_roles] = token.resource_access.transform_values do |role_map|
          role_map.roles
        end
      end
    end
  end
end
