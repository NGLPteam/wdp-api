# frozen_string_literal: true

module Testing
  class RequestMocker
    extend ActiveModel::Callbacks

    include Dry::Initializer[undefined: false].define -> do
      option :http_method, Testing::Types::HTTPMethod, default: proc { "POST" }
      option :ip, Testing::Types::String, default: proc { Testing::RandomIPAddressSet.sample }
      option :url, Testing::Types::String.constrained(http_uri: true), default: proc { LocationsConfig.default_graphql_endpoint }
      option :user_agent, Testing::Types::String, default: proc { Faker::Internet.user_agent }
    end

    DEFAULT_ENV = {
      "CONTENT_LENGTH" => ?0,
      "CONTENT_TYPE" => nil,
      "HTTP_COOKIE" => "",
      "HTTP_VERSION" => "HTTP/1.0",
      "QUERY_STRING" => "",
      "SERVER_PROTOCOL" => "HTTP/1.0",
      "SCRIPT_NAME" => "",
      "rack.test" => true,
      "rack.version" => Rack::VERSION,
    }.freeze

    define_model_callbacks :env

    after_env :set_rack_input!
    after_env :set_request_info!
    after_env :set_url_info!

    def build
      ActionDispatch::Request.new env
    end

    # @!attribute [r] env
    def env
      @env ||= build_env
    end

    private

    def build_env
      @env = DEFAULT_ENV.dup

      run_callbacks :env

      return @env
    end

    def set_url_info!
      uri = URI(url)

      set_env! "HTTP_HOST", "SERVER_NAME", value: uri.host
      set_env! "PATH_INFO", "REQUEST_URI", value: uri.path.presence || ?/
      set_env! "HTTP_PORT", "SERVER_PORT", value: uri.port.to_s
      set_env! "HTTPS", value: (uri.scheme == "https" ? "on" : "off")
      set_env! "rack.url_scheme", value: uri.scheme
    end

    def set_request_info!
      set_env! "REQUEST_METHOD", value: http_method

      set_env! "REMOTE_ADDR", value: ip

      set_env! "HTTP_USER_AGENT", value: user_agent
    end

    def set_rack_input!
      set_env! "rack.input", value: StringIO.new("")
    end

    def set_env!(*keys, value:)
      keys.each do |key|
        @env[key] = value
      end
    end
  end
end
