# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Site
    class SiteSettingsType < Types::BaseObject
      description "Configuration settings for information about this installation."

      field :installation_name, String, null: false do
        description "The name of the installation."
      end

      field :installation_home_page_copy, String, null: false do
        description "The text that appears on the root page of the frontend. Supports basic markdown."
      end

      field :logo_mode, Types::SiteLogoModeType, null: false do
        description "How the logo should be rendered"
      end

      field :provider_name, String, null: false do
        description "The name of the provider supporting and maintaining this installation."
      end

      field :footer, SiteFooterType, null: false do
        description "Settings related to the site's footer"
      end
    end
  end
end
