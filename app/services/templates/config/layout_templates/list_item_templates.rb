# frozen_string_literal: true

module Templates
  module Config
    module LayoutTemplates
      # @see Layouts::ListItemDefinition
      # @see Templates::Config::Layout::ListItem
      class ListItemTemplates < ::Templates::Config::Utility::PolymorphicTemplateMapper
        configures_templates_for_layout! :list_item
      end
    end
  end
end
