# frozen_string_literal: true

module Types
  class LinkListSelectionModeType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "DYNAMIC", value: "dynamic" do
      description <<~TEXT
      Render links from a dynamic list, determined at query time.
      TEXT
    end

    value "MANUAL", value: "manual" do
      description <<~TEXT
      Render links from a manual list set on each individual entity.
      TEXT
    end
  end
end
