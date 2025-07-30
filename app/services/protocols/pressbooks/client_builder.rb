# frozen_string_literal: true

module Protocols
  module Pressbooks
    # @see Protocols::Pressbooks::BuildClient
    class ClientBuilder < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :base_url, Protocols::Types::URL

        option :allow_insecure, Protocols::Types::Bool, default: proc { false }
      end

      standard_execution!

      # @return [Protocols::Pressbooks::Client]
      attr_reader :client

      # @return [Faraday::Connection]
      attr_reader :http

      # @return [Dry::Monads::Success(Protocols::Pressbooks::Client)]
      def call
        run_callbacks :execute do
          yield build!
        end

        Success client
      end

      wrapped_hook! def build
        @http = yield Support::System["networking.http.build_client"].(base_url, allow_insecure:, json_response: true)

        options = {
          allow_insecure:,
          base_url:,
          http:,
        }

        @client = ::Protocols::Pressbooks::Client.new(**options)

        super
      end
    end
  end
end
