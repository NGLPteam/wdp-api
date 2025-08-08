# frozen_string_literal: true

module Types
  class TemplateWidthType < Types::BaseEnum
    description <<~TEXT
    An enum that helps organize things on the frontend to put certain templates side by side where it makes sense.
    TEXT

    value "FULL", value: "full" do
      description <<~TEXT
      This template should occupy the full-width of the layout.
      TEXT
    end

    value "HALF", value: "half" do
      description <<~TEXT
      This template should occupy half of the width of the layout.

      **Note**: This should be used in concert with an adjacent HALF-width template.
      The server will not validate this is the case.
      TEXT
    end
  end
end
