# frozen_string_literal: true

class SecurityConfig < ApplicationConfig
  attr_config :encoded_private_key

  attr_config :hash_salt

  attr_config :node_salt

  def jwk
    @jwk ||= JWT::JWK.new rsa_key
  end

  def rsa_key
    @rsa_key ||= OpenSSL::PKey::RSA.new Base64.decode64(encoded_private_key)
  end
end
