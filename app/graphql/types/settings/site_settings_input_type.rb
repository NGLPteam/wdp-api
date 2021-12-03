# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Site
    class SiteSettingsInputType < Types::BaseInputObject
      description "A value for updating the site's configuration"

      argument :provider_name, String, required: true, attribute: true,
        description: "The name of the provider supporting and maintaining this installation."

      def prepare
        to_h
      end
    end
  end
end
