# frozen_string_literal: true

module Support
  module Networking
    RETRYABLE_EXCEPTIONS = [
      *::Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS,
      ::Support::Networking::MisbehavingSSLUpstream::Error,
    ].freeze

    SHRINE_REMOTE_URL_DOWNLOADER = ->(url, **options) do
      ::Support::System["networking.download"].(url, **options)
    end
  end
end
