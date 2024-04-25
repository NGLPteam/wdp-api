# frozen_string_literal: true

module Testing
  module Tokens
    # Build a keycloak token with our faked environment
    class Build
      include TestingAPI::Deps[context: "tokens.context"]

      def call(...)
        Builder.new(...).(context)
      end

      # @api private
      class Builder
        extend Dry::Initializer

        option :data, ::Testing::Types::SymbolMap, as: :initial_data, default: proc { {} }
        option :from_user, ::Testing::Types::AnyUser.optional, default: proc {}
        option :has_global_admin, ::Testing::Types::Bool, default: proc { from_user&.has_global_admin_access?.present? }
        # option :has_admin, ::Testing::Types::Bool, default: proc { from_user&.has_admin_access?.present? }

        option :realm_roles, ::Testing::Types::StringList, as: :provided_realm_roles, default: proc { [] }

        option :issued_at, ::Testing::Types::Time, default: proc { Time.current }
        option :expires_at, ::Testing::Types::Time, default: proc { 3.hours.from_now }
        option :jti, ::Testing::Types::String, default: proc { SecureRandom.uuid }
        option :with_random_jwk, ::Testing::Types::Bool, default: proc { false }

        # @param [Testing::Tokens::Context] context
        def call(context)
          payload = build_token_payload

          jwk = with_random_jwk ? context.random_jwk : context.jwk

          headers = {
            kid: jwk.kid
          }

          JWT.encode payload, jwk.keypair, context.class::ALGORITHM, headers
        end

        private

        def build_token_payload
          data = { **initial_data }

          data[:realm_roles] = [*provided_realm_roles].tap do |rr|
            rr << "global_admin" if has_global_admin
            # rr << "admin" if has_global_admin || has_admin
          end.uniq

          data[:user] = from_user

          enriched_data = FactoryBot.attributes_for :token_payload, data

          enriched_data.symbolize_keys.merge(
            aud: "keycloak",
            auth_time: issued_at.to_i,
            exp: expires_at.to_i,
            iat: issued_at.to_i,
            jti:,
            typ: "JWT",
            azp: "keycloak",
          )
        end
      end
    end
  end
end
