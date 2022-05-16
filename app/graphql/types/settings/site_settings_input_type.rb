# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Site
    class SiteSettingsInputType < Types::BaseInputObject
      include AutoHash

      description "A value for updating the site's configuration"

      argument :installation_name, String, required: false, attribute: true,
        description: "The name of the installation."

      argument :installation_home_page_copy, String, required: false, attribute: true,
        description: "The text that appears on the root page of the frontend. Supports basic markdown."

      argument :provider_name, String, required: false, attribute: true,
        description: "The name of the provider supporting and maintaining this installation."

      argument :footer, SiteFooterInputType, required: false, attribute: true,
        description: "Settings for the site's footer"
    end
  end
end
