# frozen_string_literal: true

module Templates
  module Config
    module Layout
      # @see Layouts::NavigationDefinition
      # @see Templates::Config::LayoutTemplates::NavigationTemplates
      class Navigation < ::Templates::Config::Utility::AbstractLayout
        configures_layout! :navigation

        attribute :templates, ::Templates::Config::LayoutTemplates::NavigationTemplates

        xml do
          root "navigation"

          map_element "templates", to: :templates
        end
      end
    end
  end
end
