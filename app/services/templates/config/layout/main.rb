# frozen_string_literal: true

module Templates
  module Config
    module Layout
      # @see Layouts::MainDefinition
      # @see Templates::Config::LayoutTemplates::MainTemplates
      class Main < ::Templates::Config::Utility::AbstractLayout
        configures_layout! :main

        attribute :templates, ::Templates::Config::LayoutTemplates::MainTemplates

        xml do
          root "main"

          map_element "templates", to: :templates
        end
      end
    end
  end
end
