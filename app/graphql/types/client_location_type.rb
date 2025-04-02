# frozen_string_literal: true

module Types
  class ClientLocationType < Types::BaseEnum
    description <<~TEXT
    Used to process redirect URIs for specific client locations.
    TEXT

    value "ADMIN", value: "admin" do
      description <<~TEXT
      The admin client (#{LocationsConfig.admin}).
      TEXT
    end

    value "FRONTEND", value: "frontend" do
      description <<~TEXT
      The frontend client (#{LocationsConfig.frontend}).
      TEXT
    end
  end
end
