# frozen_string_literal: true

module Users
  # This is a temporary service to create Keycloak representations of our test users.
  class SyncTesting
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[
      realm: "keycloak.realm",
      normalize_testing: "users.normalize_testing",
      update_profile: "users.update_profile",
    ]

    include MonadicPersistence

    prepend TransactionalCall

    def call(user)
      return Failure[:non_testing, "User is not a testing user"] unless user.testing?

      yield find_or_create! user

      user = yield update_profile.call user, **to_profile(user)

      user.metadata ||= {}
      user.metadata["testing"] = true

      monadic_save user
    end

    private

    def find_or_create!(user)
      user_rep = realm.users.get user.keycloak_id

      Success user_rep
    rescue RuntimeError => e
      return Failure[:keycloak_error, e.message] unless e.cause.kind_of?(RestClient::NotFound)

      create! user
    end

    def create!(user)
      user = yield normalize_testing.call user

      user_rep = realm.users.create!(
        user.username,
        user.email,
        SecureRandom.base64(32),
        false,
        "en-US"
      )

      user.update_column :keycloak_id, user_rep.id

      Success user_rep
    end

    def to_profile(user)
      user.slice(:username, :given_name, :family_name, :email).symbolize_keys
    end
  end
end
