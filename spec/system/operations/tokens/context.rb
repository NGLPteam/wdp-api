# frozen_string_literal: true

# @api private
module Testing
  module Tokens
    # @api private
    class Context
      extend Dry::Initializer

      include Dry::Core::Memoizable

      ALGORITHM = "RS256"

      DEFAULT_PEM_PATH = Rails.root.join("spec", "support", "test_key.pem").freeze

      option :pem_path, Dry::Types["coercible.string"], default: proc { DEFAULT_PEM_PATH.to_s }

      option :rack_config, Dry::Types["any"], default: proc { KeycloakRack::Config.new }

      option :default_token_leeway, Dry::Types["any"], default: proc { rack_config.token_leeway }

      # @!attribute [r] jwk
      # @return [JWT::JWK]
      memoize def jwk
        JWT::JWK.new rsa_key
      end

      # @!attribute jwks
      # @return [Hash]
      memoize def jwks
        keys = [jwk.export.reverse_merge(alg: ALGORITHM)]

        { keys: }
      end

      # @!attribute [r] rsa_key
      # @return [OpenSSL::PKey::RSA]
      memoize def rsa_key
        OpenSSL::PKey::RSA.new File.read pem_path
      end

      # @param [String] token
      # @param [Integer] leeway
      # @return [(Hash, Hash)]
      def decode_token(token, leeway: default_token_leeway)
        options = {
          algorithms: [ALGORITHM],
          leeway:,
          jwks: { keys: [jwk.export] },
        }

        JWT.decode token, nil, true, options
      end

      # @return [JWT::JWK]
      def random_jwk
        JWT::JWK.new OpenSSL::PKey::RSA.generate 2048
      end
    end
  end
end
