# frozen_string_literal: true

module Uploads
  # Generate a token that can be provided on the Upload-Token header,
  # for use with uppy / tus.js clients.
  class EncodeToken
    include Dry::Monads[:result]
    include MeruAPI::Deps[encode: "tokens.encode"]

    # @param [User] user
    # @param [{ String => String }] env the request environment
    def call(user)
      return Failure[:no_upload_access, user] unless user.has_any_upload_access?

      exp = 5.hours.from_now.to_i

      encode.call(sub: user.keycloak_id, aud: "upload", exp:)
    end
  end
end
