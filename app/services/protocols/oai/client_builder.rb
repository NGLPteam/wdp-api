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

      # @return [URI]
      attr_reader :url

      # @return [Dry::Monads::Success(::OAI::Client)]
      def call
        run_callbacks :execute do
          yield build!
        end

        Success client
      end

      wrapped_hook! def build
        @url = URI.parse(base_url)

        @http = build_faraday_connection

        options = {
          http:,
        }

        @client = ::OAI::Client.new base_url, options

        super
      end

      private

      def build_faraday_connection
        retry_options = {
          max: 10,
          interval: 0.1,
          interval_randomness: 0.9,
          backoff_factor: 2
        }

        Faraday.new(url:) do |builder|
          builder.request :retry, retry_options
          builder.response :follow_redirects, limit: 5
          builder.adapter :net_http

          if allow_insecure
            builder.ssl.verify = false
          end
        end
      end
    end
  end
end
