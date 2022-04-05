# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Institution
    class InstitutionSettingsType < Types::BaseObject
      description "Configuration settings for the specific institution featured on this installation."

      field :name, String, null: false,
        description: "The name of the institution."
    end
  end
end
