# frozen_string_literal: true

module Support
  module Routing
    # Build URL options from a simple endpoint for use with
    # Rails routing helpers.
    class BuildURLOptions
      include Dry::Monads[:result]

      # @param [String] endpoint
      # @return [Dry::Monads::Success({ Symbol => Object })]
      def call(endpoint)
        url = URI(endpoint)

        port = sanitize_port(url.port)

        options = {
          protocol: url.scheme,
          host: url.host,
          port:,
        }.compact

        Success options
      end

      private

      def sanitize_port(value)
        Support::Types::IncludedPort.try(value).to_monad.value_or(nil)
      end
    end
  end
end
