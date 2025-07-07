# frozen_string_literal: true

module Support
  module Networking
    module MisbehavingSSLUpstream
      # Faraday request middleware for properly identifying misbehaving
      # SSL upstreams who randomly hang up instead of closing the
      # connection properly.
      #
      # Would that there were a more reliable way to set `SSL_R_UNEXPECTED_EOF_WHILE_READING`
      # in Ruby, but alas.
      class RequestMiddleware < ::Faraday::Middleware
        def initialize(app, _options = nil)
          super(app)
        end

        def call(env)
          @app.call(env)
        rescue ::Faraday::ConnectionFailed, ::Faraday::SSLError => e
          ::Support::Networking::MisbehavingSSLUpstream::Error.maybe_wrap_and_reraise!(e)
        end
      end
    end
  end
end
