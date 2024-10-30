# frozen_string_literal: true

module Templates
  module Config
    module LayoutTemplates
      # @see Layouts::MainDefinition
      # @see Templates::Config::Layout::Main
      class MainTemplates < ::Templates::Config::Utility::PolymorphicTemplateMapper
        configures_templates_for_layout! :main
      end
    end
  end
end
