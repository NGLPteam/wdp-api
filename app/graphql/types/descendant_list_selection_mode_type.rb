# frozen_string_literal: true

module Types
  class DescendantListSelectionModeType < Types::BaseEnum
    description <<~TEXT
    An enum used to control the mode of selection for a descendant list template.
    TEXT

    value "DYNAMIC", value: "dynamic" do
      description <<~TEXT
      Render descendants from a dynamic ordering, determined at query time.
      TEXT
    end

    value "NAMED", value: "named" do
      description <<~TEXT
      Render descendants from a named ordering that exists on the source entity.
      TEXT
    end

    value "MANUAL", value: "manual" do
      description <<~TEXT
      Render descendants from a manual ordering set on each individual entity. See `manualListName` for how this works.
      TEXT
    end

    value "PROPERTY", value: "property" do
      description <<~TEXT
      Render entities from a schema property on the source entity.
      TEXT
    end
  end
end
