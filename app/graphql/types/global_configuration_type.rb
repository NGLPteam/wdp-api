# frozen_string_literal: true

module Types
  class GlobalConfigurationType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    global_id_field :id

    description "The global configuration for this installation of WDP."

    field :institution, Types::Settings::InstitutionSettingsType, null: false,
      description: "Settings specific to this institution."

    field :site, Types::Settings::SiteSettingsType, null: false,
      description: "Settings specific to this site"

    field :theme, Types::Settings::ThemeSettingsType, null: false,
      description: "Settings specific to the site's theme"
  end
end
