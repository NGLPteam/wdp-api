# frozen_string_literal: true

Support::System.register_provider(:request_middleware) do
  start do
    # Register our fussy SSL upstream catcher request middleware
    ::Faraday::Request.register_middleware(handle_misbehaving_ssl_upstream: ::Support::Networking::MisbehavingSSLUpstream::RequestMiddleware)
  end
end
