# frozen_string_literal: true

require "shrine/storage/s3"
require "tus/storage/s3"

aws_credentials = S3Config.to_h

bucket = UploadConfig.bucket

shared_s3_options = {
  bucket: bucket,
  http_open_timeout: 30,
  retry_limit: 10,
  use_accelerate_endpoint: false,
  **aws_credentials
}

cache_s3_options = { **shared_s3_options, prefix: "cache" }
store_s3_options = { **shared_s3_options, prefix: "store" }
derivative_s3_options = { **shared_s3_options, prefix: "derivatives" }

Tus::Server.plugin :hooks

Tus::Server.opts[:redirect_download] = true
Tus::Server.opts[:storage] = Tus::Storage::S3.new(
  concurrency: { concatenation: 20 },
  logger: Rails.logger,
  **cache_s3_options
)

Tus::Server.opts[:max_size] = 3.gigabytes

Shrine.storages = {
  cache: Shrine::Storage::S3.new(**cache_s3_options),
  store: Shrine::Storage::S3.new(**store_s3_options),
  derivatives: Shrine::Storage::S3.new(**derivative_s3_options)
}

Shrine.plugin :activerecord
Shrine.plugin :instrumentation
Shrine.plugin :backgrounding
Shrine.plugin :determine_mime_type, analyzer: :marcel, analyzer_options: { filename_fallback: true }
Shrine.plugin :type_predicates, methods: %i[pdf], mime: :marcel
Shrine.plugin :pretty_location, class_underscore: true
Shrine.plugin :tempfile # load it globally so that it overrides `Shrine.with_file`
Shrine.plugin :derivatives, create_on_promote: true, store: :derivatives
Shrine.plugin :tus

Shrine::Attacher.promote_block do
  Processing::PromoteAttachmentJob.perform_later(self.class.name, record.class.name, record.id, name, file_data)
end

Shrine::Attacher.destroy_block do
  Processing::DestroyAttachmentJob.perform_later(self.class.name, data)
end

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
    WDPAPI::Container["tokens.decode"].call(env["HTTP_UPPY_AUTH_TOKEN"])
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

WDPAPI::TusUploader = Rack::Builder.app do
  use UploadAuthMiddleware

  run Tus::Server
end
