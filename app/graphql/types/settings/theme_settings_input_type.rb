# frozen_string_literal: true

module Types
  module Settings
    class ThemeSettingsInputType < Types::BaseInputObject
      description "A value for updating the theme"

      argument :color, String, required: true, attribute: true
      argument :font, String, required: true, attribute: true

      def prepare
        to_h
      end
    end
  end
end
