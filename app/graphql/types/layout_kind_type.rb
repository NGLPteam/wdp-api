# frozen_string_literal: true

module Types
  # @see Layout
  # @see Layouts::Types::Kind
  class LayoutKindType < Types::BaseEnum
    description <<~TEXT
    The various kinds of `Layout`s in the system.
    TEXT

    value "HERO", value: "hero" do
      description <<~TEXT
      The "hero" layout for an Entity.
      TEXT
    end

    value "LIST_ITEM", value: "list_item" do
      description <<~TEXT
      A layout describing how an entity should look when it is being rendered.
      TEXT
    end

    value "MAIN", value: "main" do
      description <<~TEXT
      The "main" layout for the landing page of an entity.

      It is where most of the detail on an entity should go.
      TEXT
    end

    value "NAVIGATION", value: "navigation" do
      description <<~TEXT
      A layout describing how an entity should be navigated.
      TEXT
    end

    value "METADATA", value: "metadata" do
      description <<~TEXT
      A layout for controlling how metadata should render.
      TEXT
    end

    value "SUPPLEMENTARY", value: "supplementary" do
      description <<~TEXT
      A shared layout for certain supplementary routes like contributors and metrics.
      TEXT
    end
  end
end
