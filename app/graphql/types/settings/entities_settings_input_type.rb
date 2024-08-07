# frozen_string_literal: true

module Types
  module Settings
    # @see Settings::Entities
    class EntitiesSettingsInputType < Types::HashInputObject
      description "An object for updating EntitiesSettings"

      argument :suppress_external_links, Boolean, required: false, default_value: false, replace_null_with_default: true, attribute: true do
        description "Whether external links should be suppressed in certain schema field types."
      end
    end
  end
end
