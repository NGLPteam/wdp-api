# frozen_string_literal: true

module Templates
  module Config
    module LayoutTemplates
      # @see Layouts::NavigationDefinition
      # @see Templates::Config::Layout::Navigation
      class NavigationTemplates < ::Templates::Config::Utility::PolymorphicTemplateMapper
        configures_templates_for_layout! :navigation
      end
    end
  end
end
