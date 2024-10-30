# frozen_string_literal: true

module Templates
  module Config
    module Layout
      # @see Layouts::MetadataDefinition
      # @see Templates::Config::LayoutTemplates::MetadataTemplates
      class Metadata < ::Templates::Config::Utility::AbstractLayout
        configures_layout! :metadata

        attribute :templates, ::Templates::Config::LayoutTemplates::MetadataTemplates

        xml do
          root "metadata"

          map_element "templates", to: :templates
        end
      end
    end
  end
end
