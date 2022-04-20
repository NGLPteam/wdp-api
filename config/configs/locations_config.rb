# frozen_string_literal: true

class LocationsConfig < ApplicationConfig
  attr_config frontend: "http://localhost:14700", admin: "http://localhost:3000", api: "http://localhost:6222", debug: "http://localhost:3400"

  # @return [String]
  def default_graphql_endpoint
    URI.join(api, "/graphql").to_s
  end
end
