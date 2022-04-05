# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Site
    class SiteSettingsType < Types::BaseObject
      description "Configuration settings for information about this installation."

      field :installation_name, String, null: false,
        description: "The name of the installation."

      field :provider_name, String, null: false,
        description: "The name of the provider supporting and maintaining this installation."
    end
  end
end
