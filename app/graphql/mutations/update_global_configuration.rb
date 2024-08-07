# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::UpdateGlobalConfiguration
  class UpdateGlobalConfiguration < Mutations::BaseMutation
    description <<~TEXT
    Update the global configuration for this site.
    TEXT

    field :global_configuration, Types::GlobalConfigurationType, null: true do
      description "Though a global configuration always exists, this will be null if it fails to apply for some reason."
    end

    argument :entities, Types::Settings::EntitiesSettingsInputType, required: false, attribute: true do
      description "Possible new settings for entity behavior"
    end

    argument :institution, Types::Settings::InstitutionSettingsInputType, required: false, attribute: true do
      description "Possible new settings for the institution"
    end

    image_attachment! :logo

    clearable_attachment! :logo

    argument :site, Types::Settings::SiteSettingsInputType, required: false, attribute: true do
      description "Possible new settings for the site"
    end

    argument :theme, Types::Settings::ThemeSettingsInputType, required: false, attribute: true do
      description "Possible new settings for the theme"
    end

    performs_operation! "mutations.operations.update_global_configuration"
  end
end
