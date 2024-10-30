# frozen_string_literal: true

module Templates
  module Config
    module LayoutTemplates
      # @see Layouts::SupplementaryDefinition
      # @see Templates::Config::Layout::Supplementary
      class SupplementaryTemplates < ::Templates::Config::Utility::PolymorphicTemplateMapper
        configures_templates_for_layout! :supplementary
      end
    end
  end
end
