# frozen_string_literal: true

require "sidekiq/web"

WDPAPI::SidekiqFrontend = Rack::Builder.app do
  use Rack::Session::Cookie, secret: SecurityConfig.node_salt, same_site: true, max_age: 86_400

  run Sidekiq::Web
end
