# frozen_string_literal: true

module Testing
  module Keycloak
    class UserRegistry < AbstractResourceRegistry
      representation_klass ::KeycloakAdmin::UserRepresentation

      # @param [User] user
      # @return [void]
      def add_existing!(user)
        return unless user.kind_of?(::User)

        add_representation_for! user.keycloak_id do |repr|
          repr.first_name = user.given_name
          repr.last_name = user.family_name
          repr.email = user.email
          repr.email_verified = user.email_verified
          repr.username = user.username
        end
      end

      # @return [void]
      def remove_existing!(user)
        delete user.keycloak_id
      end
    end
  end
end
