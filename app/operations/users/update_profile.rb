# frozen_string_literal: true

module Users
  # Update a {User}'s profile attributes in keycloak, and then
  # apply that update to the local record to ensure that we are
  # in sync with the upstream provider.
  class UpdateProfile
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[realm: "keycloak.realm"]
    include MonadicPersistence

    prepend TransactionalCall

    def call(user, **profile)
      yield apply_server_update!(user, **profile)

      yield apply_local_update!(user)

      Success user
    end

    private

    def apply_server_update!(user, given_name:, family_name:, email:, username:, **attributes)
      user_rep = realm.users.get user.keycloak_id

      user_rep.first_name = given_name
      user_rep.last_name = family_name
      user_rep.email = email
      user_rep.username = username
      user_rep.attributes = attributes.stringify_keys
      user_rep.attributes["testing"] = user.testing?

      realm.users.update user.keycloak_id, user_rep

      Success nil
    end

    def apply_local_update!(user)
      user_rep = realm.users.get user.keycloak_id

      user.given_name = user_rep.first_name
      user.family_name = user_rep.last_name
      user.name = "#{user_rep.first_name} #{user_rep.last_name}"
      user.email = user_rep.email
      user.email_verified = user_rep.email_verified
      user.username = user_rep.email

      monadic_save user
    end
  end
end
