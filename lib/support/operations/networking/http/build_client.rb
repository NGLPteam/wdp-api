# frozen_string_literal: true

module Support
  module Networking
    module HTTP
      # Build an HTTP client using Faraday with a common set of middleware options,
      # including one that catches misbehaving SSL upstreams.
      #
      # @see Support::Networking::HTTP::ClientBuilder
      class BuildClient < ::Support::SimpleServiceOperation
        service_klass ::Support::Networking::HTTP::ClientBuilder
      end
    end
  end
end
