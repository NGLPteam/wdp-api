# frozen_string_literal: true

module Types
  module Settings
    class ThemeSettingsInputType < Types::HashInputObject
      description "A value for updating the theme"

      argument :color, String, required: true, attribute: true
      argument :font, String, required: true, attribute: true
    end
  end
end
