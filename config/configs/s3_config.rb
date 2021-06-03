# frozen_string_literal: true

class S3Config < ApplicationConfig
  attr_config :access_key_id, :secret_access_key, :endpoint, :region, force_path_style: false
end
