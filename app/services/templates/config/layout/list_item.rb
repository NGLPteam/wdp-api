# frozen_string_literal: true

module Templates
  module Config
    module Layout
      # @see Layouts::ListItemDefinition
      # @see Templates::Config::LayoutTemplates::ListItemTemplates
      class ListItem < ::Templates::Config::Utility::AbstractLayout
        configures_layout! :list_item

        attribute :templates, ::Templates::Config::LayoutTemplates::ListItemTemplates

        xml do
          root "list-item"

          map_element "templates", to: :templates
        end
      end
    end
  end
end
