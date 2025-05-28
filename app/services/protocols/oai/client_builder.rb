# frozen_string_literal: true

module Protocols
  module OAI
    # Build an OAI client for talking to an OAI-PMH server,
    # based on data provided by a {HarvestSource}.
    # @see Protocols::OAI::BuildClient
    # @see Protocols::OAI::BuildClientFromSource
    class ClientBuilder < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :base_url, Protocols::Types::URL

        option :allow_insecure, Protocols::Types::Bool, default: proc { false }
      end

      standard_execution!

      # @return [::OAI::Client]
      attr_reader :client

      # @return [Faraday::Connection]
      attr_reader :http

      # @return [Dry::Monads::Success(::OAI::Client)]
      def call
        run_callbacks :execute do
          yield build!
        end

        Success client
      end

      wrapped_hook! def build
        @http = yield Support::System["networking.http.build_client"].(base_url, allow_insecure:)

        options = {
          http:,
        }

        @client = ::OAI::Client.new base_url, options

        super
      end
    end
  end
end
