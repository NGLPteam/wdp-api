# frozen_string_literal: true

module Templates
  module Config
    module Layout
      # @see Layouts::HeroDefinition
      # @see Templates::Config::LayoutTemplates::HeroTemplates
      class Hero < ::Templates::Config::Utility::AbstractLayout
        configures_layout! :hero

        attribute :templates, ::Templates::Config::LayoutTemplates::HeroTemplates

        xml do
          root "hero"

          map_element "templates", to: :templates
        end
      end
    end
  end
end
