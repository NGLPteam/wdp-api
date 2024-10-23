# frozen_string_literal: true

module Types
  class DescendantListBackgroundType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "NONE", value: "none" do
      description <<~TEXT
      No background is applied to this template.
      TEXT
    end

    value "LIGHT", value: "light" do
      description <<~TEXT
      A light gradient is applied to the background of this template.
      TEXT
    end

    value "DARK", value: "dark" do
      description <<~TEXT
      A dark gradient is applied to the background of this template.
      TEXT
    end
  end
end
