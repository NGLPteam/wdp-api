# frozen_string_literal: true

class SecurityConfig < ApplicationConfig
  attr_config :encoded_basic_username

  attr_config :encoded_basic_password

  attr_config :encoded_private_key

  attr_config :hash_salt

  attr_config :node_salt

  def basic_username
    @basic_username ||= BCrypt::Password.new(encoded_basic_username)
  end

  def basic_password
    @basic_password ||= BCrypt::Password.new(encoded_basic_password)
  end

  def jwk
    @jwk ||= JWT::JWK.new rsa_key
  end

  def rsa_key
    @rsa_key ||= OpenSSL::PKey::RSA.new Base64.decode64(encoded_private_key)
  end

  # @param [String] username
  # @param [String] password
  def validate_basic_auth?(username, password)
    basic_username == username && basic_password == password
  end
end
