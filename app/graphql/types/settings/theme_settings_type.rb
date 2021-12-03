# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Theme
    class ThemeSettingsType < Types::BaseObject
      description "Configuration settings for the theme of the WDP frontend."

      field :color, String, null: false
      field :font, String, null: false
    end
  end
end
