# frozen_string_literal: true

module Types
  class ListItemSelectionModeType < Types::BaseEnum
    description <<~TEXT
    An enum used to control the mode of selection for a list item template's associated records (if applicable).
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
