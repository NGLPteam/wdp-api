# frozen_string_literal: true

require "dry/monads/result"
require "dry/matcher/result_matcher"

module Middleware
  class UploadAuthMiddleware
    include Dry::Matcher.for(:authorize, with: Dry::Matcher::ResultMatcher)
    include Dry::Monads[:result]

    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)

      return @app.call(env) if req.options?

      authorize(env) do |m|
        m.success do
          @app.call(env)
        end

        m.failure do
          build_forbidden_response
        end
      end
    end

    private

    def authorize(env)
      Common::Container["uploads.authorize"].call(env)
    end

    def build_forbidden_response
      headers = {
        "Content-Type" => "application/json"
      }

      body = {
        errors: [
          { message: "Not Authorized For Uploads" }
        ]
      }

      [
        403,
        headers,
        [body.to_json]
      ]
    end
  end
end
