# frozen_string_literal: true

module Testing
  module Tokens
    class Helper
      include TestingAPI::Deps[
        build: "tokens.build",
        context: "tokens.context",
      ]

      delegate :jwks, to: :context

      # @return [String, nil]
      def build_token(...)
        build.(...)
      end
    end
  end
end
