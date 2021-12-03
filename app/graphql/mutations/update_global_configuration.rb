# frozen_string_literal: true

module Mutations
  class UpdateGlobalConfiguration < Mutations::BaseMutation
    description <<~TEXT
    Update the global configuration for this site.
    TEXT

    field :global_configuration, Types::GlobalConfigurationType, null: true,
      description: "Though a global configuration always exists, this will be null if it fails to apply for some reason."

    argument :site, Types::Settings::SiteSettingsInputType, required: false, attribute: true,
      description: "Possible new settings for the site"
    argument :theme, Types::Settings::ThemeSettingsInputType, required: false, attribute: true,
      description: "Possible new settings for the theme"

    performs_operation! "mutations.operations.update_global_configuration"
  end
end
