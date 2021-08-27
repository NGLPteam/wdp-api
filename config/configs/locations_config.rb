# frozen_string_literal: true

class LocationsConfig < ApplicationConfig
  attr_config frontend: "http://localhost:14700", admin: "http://localhost:3000", api: "http://localhost:6222", debug: "http://localhost:3400"
end
