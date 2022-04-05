# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Institution
    class InstitutionSettingsInputType < Types::BaseInputObject
      include AutoHash

      description "An object for updating the site's configuration"

      argument :name, String, required: true, attribute: true,
        description: "The name of the institution."
    end
  end
end
