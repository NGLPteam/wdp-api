# frozen_string_literal: true

module Testing
  module Tokens
    # Decode a keycloak token generated from within our faked environment.
    #
    # @see Testing::Tokens::Build
    class Decode
      include TestingAPI::Deps[context: "tokens.context"]

      # @see Testing::Tokens::Context#decode_token
      # @param [String] token
      # @param [Integer] leeway
      # @return [(Hash, Hash)]
      def call(...)
        context.decode_token(...)
      end
    end
  end
end
