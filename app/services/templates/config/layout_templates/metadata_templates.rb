# frozen_string_literal: true

module Templates
  module Config
    module LayoutTemplates
      # @see Layouts::MetadataDefinition
      # @see Templates::Config::Layout::Metadata
      class MetadataTemplates < ::Templates::Config::Utility::PolymorphicTemplateMapper
        configures_templates_for_layout! :metadata
      end
    end
  end
end
