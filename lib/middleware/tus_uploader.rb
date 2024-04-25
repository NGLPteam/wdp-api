# frozen_string_literal: true

require "tus/server"
require_relative "upload_auth_middleware"

module Middleware
  TusUploader = Rack::Builder.app do
    use UploadAuthMiddleware

    run Tus::Server
  end
end
