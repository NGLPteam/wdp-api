# frozen_string_literal: true

module Uploads
  # A service that authorizes rack requests for upload access.
  # It allows a variable number of headers to be provided, for
  # use with tus.js via `Upload-Token` or through authenticating
  # with keycloak on `Authorize`.
  class Authorize
    include Dry::Monads[:result, :do]
    include MonadicFind
    include MeruAPI::Deps[decode_upload_token: "uploads.decode_token"]

    # Header(s) that can be provided by a tus client or similar.
    TOKEN_HEADERS = %w[HTTP_UPLOAD_TOKEN].freeze

    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Result]
    def call(env)
      user = yield authenticate env

      yield authorize user

      env["uploads.user"] = user

      Success user
    end

    def authenticate(env)
      try_upload_tokens(env).or do
        try_keycloak env
      end.or do
        unauthorized
      end
    end

    def authorize(user)
      if user.has_any_upload_access?
        Success true
      else
        unauthorized
      end
    end

    def find_user(keycloak_id)
      monadic_find_by User, keycloak_id:
    end

    def try_keycloak(env)
      return Failure[:unavailable, "No keycloak auth available"] unless env["keycloak:session"].respond_to?(:authenticate!)

      env["keycloak:session"].authenticate! do |m|
        m.success(:authenticated) do |_, token|
          find_user token.sub
        end

        m.success do
          Failure[:anonymous]
        end

        m.failure do
          Failure[:other]
        end
      end
    end

    def try_upload_tokens(env)
      start = Failure()

      TOKEN_HEADERS.reduce start do |result, header|
        result.or do
          try_upload_token(env, header)
        end
      end
    end

    def try_upload_token(env, header)
      token = env[header]

      return Failure[:unavailable, "Header #{header.inspect} unavailable"] if token.blank?

      payload = yield decode_upload_token.call token

      find_user payload["sub"]
    end

    def unauthorized
      Failure[:unauthorized, "No access to upload"]
    end
  end
end
