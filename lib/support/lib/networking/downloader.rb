# frozen_string_literal: true

module Support
  module Networking
    # A wrapper around the `down` gem that can handle misbehaving SSL upstreams.
    class Downloader
      DEFAULT_ON = [
        ::Support::Networking::MisbehavingSSLUpstream::Error
      ].freeze

      # The default number of tries to retry an error
      DEFAULT_RETRIES = 10

      # The default amount of time to sleep in between retries.
      DEFAULT_SLEEP = 1

      # @return [<Class>]
      attr_reader :on

      # Options for `down` gem.
      # @return [Hash]
      attr_reader :options

      # @return [Integer]
      attr_reader :retries

      # @return [Float, Integer, #call]
      attr_reader :sleep

      alias tries retries

      # The URL to download.
      # @return [String]
      attr_reader :url

      # @param [String] url
      # @param [Hash] options
      def initialize(url, retries: DEFAULT_RETRIES, sleep: DEFAULT_SLEEP, **options)
        @url = url
        @options = options
        @retries = retries
        @sleep = sleep
        @on = DEFAULT_ON
      end

      # @return [File]
      def call
        Retryable.retryable(on:, tries:, sleep:) do
          ::Down.download(url, **options)
        rescue ::Down::SSLError => e
          ::Support::Networking::MisbehavingSSLUpstream::Error.maybe_wrap_and_reraise!(e)
        end
      rescue ::Support::Networking::MisbehavingSSLUpstream::Error
        raise ::Shrine::Plugins::RemoteUrl::DownloadError, "Misbehaving SSL Peer"
      end
    end
  end
end
