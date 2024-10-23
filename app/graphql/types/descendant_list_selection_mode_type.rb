# frozen_string_literal: true

module Types
  class DescendantListSelectionModeType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
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
      Render descendants from a manual ordering set on each individual entity.
      TEXT
    end
  end
end
