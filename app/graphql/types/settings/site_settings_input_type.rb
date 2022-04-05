# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Site
    class SiteSettingsInputType < Types::BaseInputObject
      include AutoHash

      description "A value for updating the site's configuration"

      argument :installation_name, String, required: true, attribute: true,
        description: "The name of the installation."

      argument :provider_name, String, required: true, attribute: true,
        description: "The name of the provider supporting and maintaining this installation."
    end
  end
end
