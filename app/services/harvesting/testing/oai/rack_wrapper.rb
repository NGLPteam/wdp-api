# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      # A simple rack application that can be used in various applications,
      # particularly with Webmock in order to stub out entire test providers.
      #
      # It wraps around `OAI::Provider::Base#process_request` in order to execute
      # OAI client actions that will query our test providers.
      class RackWrapper
        include Dry::Initializer[undefined: false].define -> do
          param :provider, Harvesting::Testing::Types.Instance(::OAI::Provider::Base)
        end

        # @param [Hash] env
        # @return [(Integer, Hash, Object)]
        def call(env)
          request = Rack::Request.new(env)

          body = provider.process_request(request.params)

          headers = {
            Rack::CONTENT_LENGTH => body.bytesize,
            Rack::CONTENT_TYPE => "text/xml",
          }

          response = Rack::Response.new(body, 200, headers)

          response.to_a
        end
      end
    end
  end
end
