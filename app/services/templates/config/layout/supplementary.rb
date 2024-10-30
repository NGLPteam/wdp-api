# frozen_string_literal: true

module Templates
  module Config
    module Layout
      # @see Layouts::SupplementaryDefinition
      # @see Templates::Config::LayoutTemplates::SupplementaryTemplates
      class Supplementary < ::Templates::Config::Utility::AbstractLayout
        configures_layout! :supplementary

        attribute :templates, ::Templates::Config::LayoutTemplates::SupplementaryTemplates

        xml do
          root "supplementary"

          map_element "templates", to: :templates
        end
      end
    end
  end
end
