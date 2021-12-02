# frozen_string_literal: true

# @api private
# rubocop:disable Layout/LineLength
class TokenHelper
  extend Dry::Initializer

  ALGORITHM = "RS256"

  option :pem_path, Dry::Types["coercible.string"], default: proc { "#{__dir__}/test_key.pem" }

  def build_token(data: {}, from_user: nil, has_global_admin: nil, realm_roles: [], issued_at: Time.current, expires_at: 3.hours.from_now, jti: SecureRandom.uuid, with_random_jwk: false)
    data[:realm_roles] = [*realm_roles].tap do |rr|
      rr << "global_admin" if has_global_admin.nil? ? from_user&.has_global_admin_access? : has_global_admin.present?
    end.uniq

    data[:user] = from_user

    enriched_data = FactoryBot.attributes_for(:token_payload, data)

    payload = enriched_data.symbolize_keys.merge(
      aud: "keycloak",
      auth_time: issued_at.to_i,
      exp: expires_at.to_i,
      iat: issued_at.to_i,
      jti: jti,
      typ: "JWT",
      azp: "keycloak",
    )

    jwk = with_random_jwk ? random_jwk : self.jwk

    headers = {
      kid: jwk.kid
    }

    JWT.encode payload, jwk.keypair, ALGORITHM, headers
  end

  # @return [(Hash, Hash)]
  def decode_token(token, leeway: KeycloakRack::Config.new.token_leeway)
    options = {
      algorithms: [ALGORITHM],
      leeway: leeway,
      jwks: { keys: [jwk.export] },
    }

    JWT.decode token, nil, true, options
  end

  # @return [KeycloakRack::DecodedToken]
  def build_decoded_token(**options)
    leeway = options.delete(:leeway)

    decode_options = { leeway: leeway }

    token = build_token(**options)

    payload, headers = decode_token token, **decode_options

    KeycloakRack::DecodedToken.new payload.merge(original_payload: payload, headers: headers)
  end

  def jwk
    @jwk ||= JWT::JWK.new rsa_key
  end

  def random_jwk
    JWT::JWK.new OpenSSL::PKey::RSA.generate 2048
  end

  def jwks
    @jwks ||= { keys: [jwk.export.reverse_merge(alg: ALGORITHM)] }
  end

  def rsa_key
    @rsa_key ||= OpenSSL::PKey::RSA.new File.read pem_path
  end
end
# rubocop:enable Layout/LineLength
