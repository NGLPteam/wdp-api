# frozen_string_literal: true

module Types
  class ListItemSelectionModeType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "DYNAMIC", value: "dynamic" do
      description <<~TEXT
      TEXT
    end

    value "NAMED", value: "named" do
      description <<~TEXT
      TEXT
    end

    value "MANUAL", value: "manual" do
      description <<~TEXT
      TEXT
    end

    value "PROPERTY", value: "property" do
      description <<~TEXT
      TEXT
    end
  end
end
