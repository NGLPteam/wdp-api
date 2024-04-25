# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Site
    class SiteSettingsInputType < Types::HashInputObject
      description "A value for updating the site's configuration"

      argument :installation_name, String, required: false, attribute: true do
        description "The name of the installation."
      end

      argument :installation_home_page_copy, String, required: false, attribute: true do
        description "The text that appears on the root page of the frontend. Supports basic markdown."
      end

      argument :logo_mode, Types::SiteLogoModeType, required: false, attribute: true do
        description "How the logo should be rendered"
      end

      argument :provider_name, String, required: false, attribute: true do
        description "The name of the provider supporting and maintaining this installation."
      end

      argument :footer, SiteFooterInputType, required: false, attribute: true do
        description "Settings for the site's footer"
      end
    end
  end
end
