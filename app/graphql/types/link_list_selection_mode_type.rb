# frozen_string_literal: true

module Types
  class LinkListSelectionModeType < Types::BaseEnum
    description <<~TEXT
    An enum used to control the mode of selection for a link list template.
    TEXT

    value "DYNAMIC", value: "dynamic" do
      description <<~TEXT
      Render links from a dynamic list, determined at query time.
      TEXT
    end

    value "MANUAL", value: "manual" do
      description <<~TEXT
      Render links from a manual list set on each individual entity. See `manualListName` for how this works.
      TEXT
    end
  end
end
