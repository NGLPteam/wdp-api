# frozen_string_literal: true

module Harvesting
  module OAI
    class BuildClient
      include Dry::Monads[:result]

      # @param [HarvestSource] harvest_source
      # @return [OAI::Client]
      def call(harvest_source)
        options = {
          http: build_faraday(harvest_source),
        }

        client = ::OAI::Client.new harvest_source.base_url, options

        Success client
      end

      private

      def build_faraday(harvest_source)
        url = URI.parse harvest_source.base_url

        retry_options = {
          max: 10,
          interval: 0.1,
          interval_randomness: 0.9,
          backoff_factor: 2
        }

        Faraday.new(url: url) do |builder|
          builder.request :retry, retry_options
          builder.response :follow_redirects, limit: 5
          builder.adapter :net_http
        end
      end
    end
  end
end
