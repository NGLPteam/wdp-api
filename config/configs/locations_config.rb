# frozen_string_literal: true

class LocationsConfig < ApplicationConfig
  attr_config frontend: "http://localhost:14700", backend: "http://localhost:14725", api: "localhost:14750"
end
