# frozen_string_literal: true

module Middleware
  PGHeroFrontend = Rack::Builder.app do
    use Rack::Session::Cookie, secret: SecurityConfig.node_salt, same_site: true, max_age: 86_400
    use Rack::Auth::Basic do |username, password|
      SecurityConfig.validate_basic_auth?(username, password)
    end

    run PgHero::Engine
  end
end
