# frozen_string_literal: true

module Testing
  module Tokens
    # Build a KeycloakRack::DecodedToken (for debugging purposes)
    #
    # @api private
    # @see Testing::Tokens::Build
    # @see Testing::Tokens::Decode
    class BuildDecoded
      include TestingAPI::Deps[
        build: "tokens.build",
        context: "tokens.context",
        decode: "tokens.decode",
      ]

      # @param [Integer] leeway
      # @param [Hash] options
      # @return [KeycloakRack::DecodedToken]
      def call(leeway: context.default_token_leeway, **options)
        token = build.(**options)

        original_payload, headers = decode.(token, leeway:)

        KeycloakRack::DecodedToken.new original_payload.merge(original_payload:, headers:)
      end
    end
  end
end
